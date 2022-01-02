clear, close all, clc; 
syms t;
%Analiza czasowo-częstotliwościowa układu RLC
% Autorzy: Paweł Tymoczko, Igor Siemek

%wartości elementów układu i napięcie wyjściowe
%GITHUB
%https://github.com/How2Troll/Projekt_RLC_PT_IS
R1 = 1000;
R2 = 500;
L = 50;
C = 0.00002;
f = 50;
U = 10*cos(2*pi*f*t)+ 5*cos(2*2*pi*f*t) +5;


%analiza obwodu metodą operatorową
ZC = laplace(t/t) / C; %impedancja kondensatora w laplce
ZL = (laplace(1*t/t))^(-1)*L; %imepdancja cewki w laplace
ZZ = ZC + R1 + ((R2 * ZL)/(R2 + ZL)); %impedancja zastepcza w laplce

Us = laplace(U);

Is = Us/ZZ;
I = ilaplace(Is);

IsR2 = Is * ( ZL / (R2 + ZL)); %prad R2
IR2 = ilaplace(IsR2);

IsL = Is * ( R2 / (R2 + ZL)); % prad L
IL = ilaplace(IsL);

UsL = IsL * ZL; %napiecie na L
UL = ilaplace(UsL);

UsR2 = IsR2 * R2; %napiecie na R2
UR2 = ilaplace(UsR2);

UsR1 = Is * R1; %napiecie na R1
UR1 = ilaplace(UsR1);

UsC = Is * ZC; %napiecie na C
UC = ilaplace(UsC);

%Przebiegi czasowe
u = matlabFunction(U); 
i = matlabFunction(I); 
iR2 = matlabFunction(IR2); 
iL = matlabFunction(IL); 
uL = matlabFunction(UL); 
uR2 = matlabFunction(UR2);
uR1 = matlabFunction(UR1);
uC = matlabFunction(UC); 

Fs = 300; % czestotliwosc probkowania
T = 1/Fs; % okres probkowania
L = 1000; % ilosc probek
t = (0:L-1)*T; % dziedzina czasu
f = Fs*(0:(L/2))/L; %dziedzina czestotliwosci

%obliczanie transformaty Fouriera sygnałów z wykorzystaniem algorytmu FFT
u_f=fft(u(t)/L);
i_f=fft(i(t)/L);
iR2_f=fft(iR2(t)/L);
iL_f=fft(iL(t)/L);
uL_f=fft(uL(t)/L);
uR2_f=fft(uR2(t)/L);
uR1_f=fft(uR1(t)/L);
uC_f=fft(uC(t)/L);


%widma aplitudowe sygnałów

% U
A_uf2=abs(u_f);
A_uf=A_uf2(1:L/2 +1);
A_uf(2:end-1) = 2*A_uf(2:end-1);
% I
A_if2=abs(i_f);
A_if=A_if2(1:L/2 +1);
A_if(2:end-1) = 2*A_if(2:end-1);
% IR2
A_iR2f2=abs(iR2_f);
A_iR2f=A_iR2f2(1:L/2 +1);
A_iR2f(2:end-1) = 2*A_iR2f(2:end-1);
%IL
A_iLf2=abs(iL_f);
A_iLf=A_iLf2(1:L/2 +1);
A_iLf(2:end-1) = 2*A_iLf(2:end-1);
%UL
A_uLf2=abs(uL_f);
A_uLf=A_uLf2(1:L/2 +1);
A_uLf(2:end-1) = 2*A_uLf(2:end-1);
%UR1
A_uR1f2=abs(uR1_f);
A_uR1f=A_uR1f2(1:L/2 +1);
A_uR1f(2:end-1) = 2*A_uR1f(2:end-1);
%UR2
A_uR2f2=abs(uR2_f);
A_uR2f=A_uR2f2(1:L/2 +1);
A_uR2f(2:end-1) = 2*A_uR2f(2:end-1);
%UC
A_uCf2=abs(uC_f);
A_uCf=A_uCf2(1:L/2 +1);
A_uCf(2:end-1) = 2*A_uCf(2:end-1);

%widma fazowe sygnałów
fi_uf2=unwrap(angle(u_f));
fi_uf=fi_uf2(1:L/2 +1);

fi_if2=unwrap(angle(i_f));
fi_if=fi_if2(1:L/2 +1);

fi_iLf2=unwrap(angle(iL_f));
fi_iLf=fi_iLf2(1:L/2 +1);

fi_iR2f2=unwrap(angle(iR2_f));
fi_iR2f=fi_iR2f2(1:L/2 +1);

fi_uLf2=unwrap(angle(uL_f));
fi_uLf=fi_uLf2(1:L/2 +1);

fi_uR2f2=unwrap(angle(uR2_f));
fi_uR2f=fi_uR2f2(1:L/2 +1);

fi_uR1f2=unwrap(angle(uR1_f));
fi_uR1f=fi_uR1f2(1:L/2 +1);

fi_uCf2=unwrap(angle(uC_f));
fi_uCf=fi_uCf2(1:L/2 +1);

%Prezentacja wyników
t_domain=(0:0.001:0.25);

figure('Name','Napięcie wejściowe i prąd cewki L/kondenatora C', 'NumberTitle','off')
    subplot(2,3,1)
    plot(t_domain,u(t_domain))
    ylabel("napiecie [V]");
    xlabel("czas [s]");
    title("Napięcie wejściowe");
    
    subplot(2,3,2)
    plot(f,A_uf)
    ylabel("amplituda");
    xlabel("czestotliwosc [f]");
    title("Widmo amplitudowe napięcia wejściowego");

    subplot(2,3,3)
    plot(f,fi_uf)
    ylabel("faza");
    xlabel("czestotliwosc [f]");
    title("Widmo fazowe napięcia wejsciowego");
    
    subplot(2,3,4)
    plot(t_domain,i(t_domain))
    ylabel("prąd [A]");
    xlabel("czas [s]");
    title("Prąd wejściowy");
    
    subplot(2,3,5)
    plot(f,A_if)
    ylabel("amplituda");
    xlabel("czestotliwosc [f]");
    title("Widmo amplitudowe prądu wejściowego");
    
    subplot(2,3,6)
    plot(f,fi_if)
    ylabel("faza [rad]");
    xlabel("czestotliwosc [f]");
    title("Widmo fazowe prądu wejściowego");
   
figure('Name','Napięcie i prąd cewki L', 'NumberTitle','off')
    subplot(2,3,1)
    plot(t_domain,uL(t_domain))
    ylabel("napiecie [V]");
    xlabel("czas [s]");
    title("Napięcie na cewce");
    
    subplot(2,3,2)
    plot(f,A_uLf)
    ylabel("amplituda");
    xlabel("czestotliwosc [f]");
    title("Widmo amplitudowe napięcia na cewce");
    
    subplot(2,3,3)
    plot(f,fi_uLf)
    ylabel("faza [rad]");
    xlabel("czestotliwosc [f]");
    title("Widmo fazowe napięcia na cewce");  
    
    subplot(2,3,4)
    plot(t_domain,iL(t_domain))
    ylabel("prąd [A]");
    xlabel("czas [s]");
    title("Prąd na cewce");
    
    subplot(2,3,5)
    plot(f,A_iLf)
    ylabel("amplituda");
    xlabel("czestotliwosc [f]");
    title("Widmo amplitudowe prądu na cewce");
    
    subplot(2,3,6)
    plot(f,fi_iLf)
    ylabel("faza [rad]");
    xlabel("czestotliwosc [f]");
    title("Widmo fazowe prądu na cewce");
    
figure('Name','Napięcie i prąd rezystora R2', 'NumberTitle','off')
    subplot(2,3,1)
    plot(t_domain,uR2(t_domain))
    ylabel("napiecie [V]");
    xlabel("czas [s]");
    title("Napiecie na R2");
    
    subplot(2,3,2)
    plot(f,A_uR2f)
    ylabel("amplituda");
    xlabel("czestotliwosc [f]");
    title("Widmo amplitudowe napięcia na R2");
    
    subplot(2,3,3)
    plot(f,fi_uR2f)
    ylabel("faza [rad]");
    xlabel("czestotliwosc [f]");
    title("Widmo fazowe napięcia na R2");
    
    subplot(2,3,4)
    plot(t_domain,iR2(t_domain))
    ylabel("prąd [A]");
    xlabel("czas [s]");
    title("Prąd na R2"); 
    
    subplot(2,3,5)
    plot(f,A_iR2f)
    ylabel("amplituda");
    xlabel("czestotliwosc [f]");
    title("Widmo amplitudowe prądu na R2");
    
    subplot(2,3,6)
    plot(f,fi_iR2f)
    ylabel("faza [rad]");
    xlabel("czestotliwosc [f]");
    title("Widmo fazowe prądu na R2");
    
figure('Name','Napięcie kondensatora C i rezystora R1', 'NumberTitle','off')
    subplot(2,3,1)
    plot(t_domain,uC(t_domain))
    ylabel("napiecie [V]");
    xlabel("czas [s]");
    title("Napięcie na C");
    
    subplot(2,3,2)
    plot(f,A_uCf)
    ylabel("amplituda");
    xlabel("czestotliwosc [f]");
    title("Widmo amplitudowe napięcia na C");
    
    subplot(2,3,3)
    plot(f,fi_uCf)
    ylabel("faza [rad]");
    xlabel("czestotliwosc [f]");
    title("Widmo fazowe napięcia na C");
    
    subplot(2,3,4)
    plot(t_domain,uR1(t_domain))
    ylabel("napiecie [V]");
    xlabel("czas [s]");
    title("Napiecie na R1");
    
    subplot(2,3,5)
    plot(f,A_uR1f)
    ylabel("amplituda");
    xlabel("czestotliwosc [f]");
    title("Widmo prądu napięcia na R1");
    
    subplot(2,3,6)
    plot(f,fi_uR1f)
    ylabel("faza [rad]");
    xlabel("czestotliwosc [f]");
    title("Widmo fazowe napięcia na R1");
    





%Wykresy przebiegow czasowych DO POPRAWY (na koniec)
% 2 kolumny, 4 wiersze x3 (czasowe, amplitudowe, fazowe)

% %--PRADY--
% figure('Name','Przebiegi czasowe natezen pradu na elementach obwodu','NumberTitle','off');
% 
% %prad R1 = C = IL + IR2
% subplot(1,1,1);
% fplot(It * 1000, 'b')
% axis([0 0.1 -10 10]);
% ylabel("i[mA]");
% xlabel("t[s]");
% title("Wykres natezenia pradu i(t) na R1 oraz C")
% 
% %prad cewka
% subplot(3,1,2);
% fplot(IL * 1000, 'r')
% axis([0 0.1 -0.5 0.5]);
% ylabel("i[mA]");
% xlabel("t[s]");
% title("Wykres natezenia pradu i(t) na cewce L")
% 
% %prad R2
% subplot(3,1,3);
% fplot(IR2 * 1000, 'r')
% axis([0 0.1 -10 10]);
% ylabel("i[mA]");
% xlabel("t[s]");
% title("Wykres natezenia pradu i(t) na cewce R2")
% 
% 
% 
% %--NAPIECIA--
% figure('Name','Przebiegi czasowe napiecia na elementach obwodu','NumberTitle','off');

%napiecie wejsciowe
% subplot(5,1,1);
% fplot(U, 'r')
% axis([0 0.1 -6 16]);
% ylabel("u[V]");
% xlabel("t[s]");
% title("Wykres napiecia u(t) na wejsciu")
% 
% %napiecie R1
% subplot(5,1,2);
% fplot(UR1, 'r')
% axis([0 0.1 -10 10]);
% ylabel("u[V]");
% xlabel("t[s]");
% title("Wykres napiecia uR1(t) na wejsciu")
% 
% %napiecie RC
% subplot(5,1,3);
% fplot(UC, 'r')
% axis([0 0.1 -10 10]);
% ylabel("u[V]");
% xlabel("t[s]");
% title("Wykres napiecia uC(t) na wejsciu")
% 
% %napiecie R2
% subplot(5,1,4);
% fplot(UR2, 'r')
% axis([0 0.1 -10 10]);
% ylabel("u[V]");
% xlabel("t[s]");
% title("Wykres napiecia uR2(t) na wejsciu")
% 
% %napiecie L
% subplot(5,1,5);
% fplot(UL, 'r')
% axis([0 0.1 -10 10]);
% ylabel("u[V]");
% xlabel("t[s]");
% title("Wykres napiecia uL(t) na wejsciu")

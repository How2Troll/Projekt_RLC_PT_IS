% Analiza czasowo-częstotliwościowa układu RLC
% Autorzy: Jakub Tomaszewski, Mateusz Piechnik

% Wartości poszczególnych elementów układu:
syms t;
R1 = 500; R2 = 1000; L=0.05; C=0.000001; w=1000; U=5*sin(w*t);

% -----------------Analiza czasowa-----------------------

Zc = laplace(t/t)/C;                      % Obliczenie wartości reaktancji kondensatora w dziedzinie operatorowej
Zl = [laplace((1*t/t))]^(-1)*L;           % Obliczenie wartości reaktancji cewki w dziedzinie operatorowej
Z1 = R1;                                  % Wartość impedancji na pierwszej gałęzi (potrzebna do dzielnika prądu)
Z2 = R2+Zc;                               % Wartość impedancji na drugiej gałęzi

Z = [(Z2*R1)/(Z2+R1)]+Zl;                   % Impedancja zastępcza układu  

Es = laplace(U);                            % Obliczenie wartości źródła napięcia w dziedzinie operatorowej, wykorzystując transformatę Laplace'a

Is = Es/Z;                                  % Obliczenie całkowitego prądu w obwodzie (prąd na cewce) w oparciu o prawo Ohma
it = ilaplace(Is)                           % Wartość prądu w dziedzinie czasu. Prąd ten jest sumą prądów i1 oraz i2 (z prawa Kirchhoffa)

I1s = Is*(Z2/(Z1+Z2));                      % Obliczenie w dziedzinie transformat prądów i1 oraz i2 w oparciu o dzielnik prądu
I2s = Is*(Z1/(Z1+Z2));

i1 = ilaplace(I1s)                          % Transformaty odwrotne obliczonych wyżej prądów
i2 = ilaplace(I2s)

Uls = Is*Zl;                                % Wartości napięć na cewce
Ucs = I2s*Zc;                               % oraz na kondensatorze w dziedzinie transformat

ul = ilaplace(Uls)                          % Transformaty odwrotne powyższych napięć
uc = ilaplace(Ucs)
ur1 = i1*R1                                 % Napięcia na rezystorach nie wymagały obliczeń w dziedzinie operatorowej
ur2 = i2*R2                                 % Wyliczony wcześniej prąd i1 oraz wartości rezystancji są w dziedzinie czasu


% Wykresy napięć i natężeń na elementach obwodu dla analizy czasowej

figure('Name','Przebiegi czasowe natężeń prądu na elementach obwodu','NumberTitle','off');

subplot(3,1,1);
fplot(it, 'g')
axis([0 0.1 -0.015 0.015]);
ylabel("I[A]");
xlabel("t[s]");
title("Wykres natężenia na cewce L (prądu źródła) w zależności od czasu:");

subplot(3,1,2);
fplot(i1, 'r')
axis([0 0.1 -0.015 0.015]);
ylabel("I[A]");
xlabel("t[s]");
title("Wykres natężenia prądu na rezystorze R1 w zależności od czasu:");

subplot(3,1,3);
fplot(i2)
axis([0 0.1 -0.015 0.015]);
ylabel("I[A]");
xlabel("t[s]");
title("Wykres natężenia prądu na kondensatorze C oraz rezystorze R2 w zależności od czasu:");


figure('Name','Przebiegi czasowe napięcia na elementach obwodu','NumberTitle','off');

subplot(5,1,1)
fplot(U)
axis([0 0.1 -5.5 5.5]);
ylabel("U[V]");
xlabel("t[s]");
title("Wykres napięcia na generatorze:");

subplot(5,1,2)
fplot(ul, 'g')
axis([0 0.1 -1 1]);
ylabel("U[V]");
xlabel("t[s]");
title("Wykres napięcia na na cewce L w zależności od czasu:");

subplot(5,1,3)
fplot(ur1, 'r')
axis([0 0.1 -5.5 5.5]);
ylabel("U[V]");
xlabel("t[s]");
title("Wykres napięcia na na rezystorze R1 w zależności od czasu:");

subplot(5,1,4)
fplot(uc)
axis([0 0.1 -5 5]);
ylabel("U[V]");
xlabel("t[s]");
title("Wykres napięcia na na kondensatorze C w zależności od czasu:");

subplot(5,1,5)
fplot(ur2, 'k')
axis([0 0.1 -5 5]);
ylabel("U[V]");
xlabel("t[s]");
title("Wykres napięcia na na rezystorze R2 w zależności od czasu:");

% ------------------Analiza częstotliwościowa-------------------------























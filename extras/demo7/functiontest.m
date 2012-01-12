knee = 20;
range = 0:400;
f = 1.8 ./ (1+exp((-range+knee)/knee) ) - 0.8;
plot (range,f);


;
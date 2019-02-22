function v = freqToSpeed(freq)
    f0 = 24.13e9;
    c = 299792458;
    v = (freq.*c)./(2*f0);
    
end
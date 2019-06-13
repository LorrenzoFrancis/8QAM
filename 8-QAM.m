clc;            % clear screen
clear;          % clear memory
close all;      % closes all other windows


prompt = {'Enter bit sequence below (max 51 bits):'}; % prompt for user
ititle = 'Input'; % title of dialog box
dims = [1 50]; % dimensions of dialog box
temp1 = inputdlg(prompt,ititle,dims); % takes in user input

if rem(length(temp1{1}),3) ~= 0 % checks the number of bits
    
    (msgbox('Invalid data entered. Please try again','Error','error')); % error message if an odd number of bits in entered
    
else

temp2 = bin2dec(temp1{1}); %converts user input from binary  to decimal
bit_sequence = str2num(dec2bin(temp2,length(temp1{1})).'); %converts decimal to a binary string array then to number array
  
b_s_length = temp1{1};

data_NRZ = 2 * bit_sequence - 1; % data represented at non-return-to zero form for QPSK modulation
s_p_data = reshape(data_NRZ,3,length(bit_sequence)/3);    % S/P conversion of data
 

bit_rate = 10^6; % fixed bit rate
f = bit_rate;    % for 8QAM bit rate is minimum carrier frequency
T = 1 / bit_rate; 
t = T / 99 : T / 99 : T; 


%%%%%%%%%%%%%%%%%%%%%%   CODE FOR 8 QAM     %%%%%%%%%%%%%

y = []; % intialize vector for transmitted signal

for i = 1:length(bit_sequence)/3
    
    if s_p_data(3,i) == 1 % if c bit = 1
        inphase_component =s_p_data(2,i) * 1.307 * sin(2*pi*f*t);
        quadrature_component = s_p_data(1,i) * 1.307 * cos(2*pi*f*t);
        y = [y inphase_component + quadrature_component];
    else % if c bit = 0
        inphase_component = s_p_data(2,i) * 0.541 * sin(2*pi*f*t);
        quadrature_component = s_p_data(1,i) * 0.541 * cos(2*pi*f*t);
        y = [y inphase_component + quadrature_component];
    end
end
    
 
Transmitted_signal = y;
 
tt = T/99:T/99:(T * length(b_s_length))/3;
 
figure(1) %graphs

subplot(2,1,1);
stem(bit_sequence,'linewidth',3,'Color',[.31 .50 .79]), grid on;
title('Data Before Modulation');
xlabel('bit sequence');
ylabel(' value');
axis([0 length(b_s_length)+1 0 1.5]);     %x axis range is from 0 to 1 + number of bits entered while the y axis range is from 0 to 1.5


subplot(2,1,2);
plot(tt,Transmitted_signal,'m','linewidth',3), grid on;
title('Modulated 8-QAM Signal');
xlabel('time(s)');
ylabel(' amplitude(V)');

end

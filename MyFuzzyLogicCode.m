clear ard_brd   % to clear any previous instance of a

% Creating an arduino project
ard_brd = arduino('com3', 'uno', 'Libraries', 'Servo');

% Creating servo motor object
servo_m = servo(ard_brd, 'D4');

% Read the analog voltages
val1 = readVoltage(ard_brd,'A1');  % value from sensor1 of the panel
val2 = readVoltage(ard_brd,'A2');  % value from sensor2 of the panel

% Convert to corresponding digital voltage using
% the insternal ADC of Arduino Uno 
val1 = ardMapFun(val1, 0, 1023, 0, 180);
val2 = ardMapFun(val2, 0, 1023, 0, 180);

pos = 90; % Position of the panel at midday for max light

if val1 > (val2 + 50)
    if pos < 180
        pos = pos + 1;
    end
    writePosition(servo_m, pos);   % Moving the servo to the position
    current_pos = readPosition(servo_m);   % Reading the current position
    fprintf('Backward \n');
    fprintf('Current Position is %d \n', current_pos);   % Printing the Current position
    pause(1);
    
elseif val2 > (val1 + 50)
    if pos > 0
        pos = pos - 1;
    end
    writePosition(servo_m, pos);   % Moving the servo to the position
    current_pos = readPosition(servo_m);   % Reading the current position
    fprintf('Forward \n');
    fprintf('Current Position is %d \n', current_pos);   % Printing the Current position
    pause(1);
else
    writePosition(servo_m, 0);
    fprint('It is NIGHT TIME \n');
    pause(0.1)
end


fileName = 'step2.m';
mlintID = 'NOPTS';                       %# The ID of the warning
mlintData = mlint(fileName,'-id');       %# Run mlint on the file
index = strcmp({mlintData.id},mlintID);  %# Find occurrences of the warnings...
lineNumbers = [mlintData(index).line];   %#   ... and their line numbers

%# Read the lines of code from the file:

fid = fopen(fileName,'rt');
linesOfCode = textscan(fid,'%s','Delimiter',char(10));  %# Read each line
fclose(fid);

%# Modify the lines of code:

linesOfCode = linesOfCode{1};  %# Remove the outer cell array encapsulation
linesOfCode(lineNumbers) = strcat(linesOfCode(lineNumbers),';');  %# Add ';'

%# Write the lines of code back to the file:

fid = fopen(fileName,'wt');
fprintf(fid,'%s\n',linesOfCode{1:end-1});  %# Write all but the last line
fprintf(fid,'%s',linesOfCode{end});        %# Write the last line
fclose(fid);
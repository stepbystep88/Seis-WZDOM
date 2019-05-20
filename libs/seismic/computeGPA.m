function computeGPA(p)
%p=1;%,本科成绩
p=2;%研究生成绩
%p=3;%博士成绩
if p==1
    grade = load('C:\Users\Administrator\Desktop\GPA\本科成绩.txt');
elseif p==2
    grade = load('C:\Users\Administrator\Desktop\GPA\研究生成绩.txt');
elseif p==3
    grade = load('C:\Users\Administrator\Desktop\GPA\博士成绩.txt');
end
num_class = size(grade,1);
gpaGrade = zeros(num_class,1);
for i=1:num_class
    if 85<=grade(i,2)
        gpaGrade(i) = 4;
    elseif 70<=grade(i,2)
        gpaGrade(i) = 3;
    elseif 60<=grade(i,2)
        gpaGrade(i) = 2;
    else
        gpaGrade(i) = 1;
    end
end
GPA4 = sum(grade(:,1).*gpaGrade)/sum(grade(:,1))
GPA100 = sum(grade(:,1).*grade(:,2))/sum(grade(:,1));
end
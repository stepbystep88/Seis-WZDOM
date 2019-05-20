function fun=savetxtfile(filename,data,m,n)

fid=fopen(filename,'wt');%写入文件路径  
%获取矩阵的大小，welldatas为要输出的矩阵
for i=1:1:m
    for j=1:1:n
        fprintf(fid,'%20.5f ',data(i,j)); 
    end
    fprintf(fid,'\n');
end
fclose(fid); 
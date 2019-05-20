% 	
%	
% An m-file to apply the Golden Section Method
%************************************
% requires:     UpperBound_nVar.m
%***************************************
%
% the following information are passed to the function

% the name of the function 			'functname'
% this function should be available as a function m-file
% and should return the value of the function 
% corresponding to a design vector given a vector
%
% the tolerance										0.001

% following needed for UpperBound_nVar
% the current position vector				x
% the current search direction			s
% the initial value							lowbound
% the incremental value 					intvl
% the number of scanning steps	    	ntrials
%
% the function returns a row vector of the following
% alpha(1),f(alpha1), design variables at alpha(1) 
% for the last iteration 

%	sample callng statement

% GoldSection_nVar('Example5_2',0.001,[0 0 0 ],[0 0 6],0,0.1,10)
%
function ReturnValue = ...
   GoldSection_nVar(functname,tol,x,s,lowbound,intvl,ntrials)
format compact;

% find upper bound
upval = UpperBound_nVar(functname,x,s,lowbound,intvl,ntrials);
au=upval(1);	fau = upval(2);

% if upper bound returns value close to lowbound 
% return to the calling procedure to reverse the direction of the 
% search vector and try again

if (au <= 1.0e-06)
   aL = lowbound;  xL = x + aL*s;  
   faL =feval(functname,xL);
   ReturnValue =[aL faL x];
   return
end


if (tol == 0) tol = 0.0001;  %default
end

eps1 = tol/(au - lowbound);
tau = 0.38197;
nmax = round(-2.078*log(eps1)); % no. of iterations




aL = lowbound;              xL = x + aL*s;  faL =feval(functname,xL);	
a1 = (1-tau)*aL + tau*au;   x1 = x + a1*s; fa1 = feval(functname,x1);
a2 = tau*aL + (1 - tau)*au; x2 = x + a2*s; fa2 = feval(functname,x2);

% storing all the four values for printing 
% remember to suppress printing after debugging
%fprintf('start  \n')
%fprintf('alphal(low)   alpha(1)   alpha(2)  alpha{up) \n')
avec = [aL a1 a2 au;faL fa1 fa2 fau];
%disp([avec])
for i = 1:nmax

	if fa1 >= fa2
   	aL = a1;	faL = fa1;
   	a1 = a2;	fa1 = fa2;
      a2 = tau*aL + (1 - tau)*au;	x2 = x + a2*s; 
          fa2 = feval(functname,x2);

   	au = au;	fau = fau;  % not necessary -just for clarity
      
      
      %fprintf('\niteration '),disp(i)
      %fprintf('alphal(low)   alpha(1)   alpha(2)  alpha{up) \n')
      avec = [aL a1 a2 au;faL fa1 fa2 fau];
		%disp([avec])

	else
  	   au = a2;	fau = fa2;
   	a2 = a1;	fa2 = fa1;
      a1 = (1-tau)*aL + tau*au;	x1 = x + a1*s; 
          fa1 = feval(functname,x1);
   	aL = aL;	faL = faL;  % not necessary
      
      %fprintf('\niteration '),disp(i)
      %fprintf('alphal(low)   alpha(1)   alpha(2)  alpha{up) \n')
      avec = [aL a1 a2 au;faL fa1 fa2 fau];
		%disp([avec])

	end
end
%fprintf('final  \n')
%fprintf('alphal(low)   alpha(1)   alpha(2)  alpha{up) \n')
avec = [aL a1 a2 au;faL fa1 fa2 fau];
%disp([avec])

% returns the value at the last iteration
ReturnValue =[a1 fa1 x1];
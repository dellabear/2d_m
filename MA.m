function [e ] = MA( q,N, M )

% q=1: GS iteration
% q=2: ADI iteration
% q=0: Jacobi iteration


ax = 0; 
bx = 1;
ay = 0; 
by = 1;
nx = N+1; 
h = (bx-ax)/(nx-1);
ny = nx; 
by = ay + (ny-1)*h;
ii = 1:nx; x = ax + (ii-1)*h;
jj = 1:ny; y = ay + (jj-1)*h;
[X,Y] = ndgrid(x,y);	% like meshgrid but x index is first, y is second

% set up the arrays for solution, forcing, and analytical solution

u = zeros(nx,ny);
f = zeros(nx,ny);
uexact = zeros(nx,ny);

% set up the analytical solution

uexact = ufun( X, Y );

% set up the forcing

f = ffun( X, Y );
% set up the boundary values

u(1:nx, 1) = uexact(1:nx, 1);
u(1:nx,ny) = uexact(1:nx,ny);

u( 1,1:ny) = uexact( 1,1:ny);
u(nx,1:ny) = uexact(nx,1:ny);  


rnorm(1)=norm( resid(f,u,h) )*h;
enorm(1)= norm( u-uexact )*h;

if q==1 
    
for i=2:M
      u = gsrelax( f, u, h );    
      enorm(i)= max(max(abs(u-uexact)));
      rnorm(i)= norm( resid(f,u,h))*h;
            if norm(enorm(i)-enorm(i-1),inf)<=1.0e-8, break, end; % quit loop if converged
end

sweeps=1:i;
e=u-uexact;


%plot residual vs. number of sweeps
subplot(1,2,1);
semilogy(sweeps,rnorm,'r*-');
xlabel('Relaxation sweeps');
ylabel('Residual Norm');
title('GS Iteration');

% plot solution error vs. number of sweeps
subplot(1,2,2);
semilogy(sweeps,enorm,'r*-');
xlabel('Relaxation sweeps');
ylabel('Error Norm');
title('GS Iteration');


elseif q==2
      
    for i=2:M  
      u = ADI( f, u, h );
      enorm(i)= max(max(abs(u-uexact)));
      rnorm(i)= norm( resid(f,u,h))*h;
         if norm(enorm(i)-enorm(i-1),inf)<=1.0e-8, break, end; % quit loop if converged
    end
    
sweeps=1:i;
e=u-uexact;

%plot residual vs. number of sweeps
subplot(1,2,1);
semilogy(sweeps,rnorm,'r*-');
xlabel('Relaxation sweeps');
ylabel('Residual Norm');
title('ADI Iteration');

% plot solution error vs. number of sweeps
subplot(1,2,2);
semilogy(sweeps,enorm,'r*-');
xlabel('Relaxation sweeps');
ylabel('Error Norm');
title('ADI Iteration');

else

    for i=2:M      
      u = jacobi( f, u, h );
      enorm(i)= max(max(abs(u-uexact)));
      rnorm(i)= norm( resid(f,u,h))*h;
            if norm(enorm(i)-enorm(i-1),inf)<=1.0e-8, break, end; % quit loop if converged
 
    end
    
sweeps=1:i;
e=u-uexact;

%plot residual vs. number of sweeps
subplot(1,2,1);
semilogy(sweeps,rnorm,'r*-');
xlabel('Relaxation sweeps');
ylabel('Residual Norm');
title('Jacobi Iteration');

%plot solution error vs. number of sweeps
subplot(1,2,2);
semilogy(sweeps,enorm,'r*-');
xlabel('Relaxation sweeps');
ylabel('Error Norm');
title('Jacobi Iteration');

end



end
    


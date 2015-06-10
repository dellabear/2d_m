function v = jacobi( f, u, h )
% GSRELAX  Does one sweep of Gauss-Seidel relaxation for the Monge-Ampere problem
%
% Usage:  u = gsrelax( f, u, h )
%
% Input
%    f    right-hand side
%    u    current approximation
%    h    mesh spacing
% Returns
%    u    updated

[nx,ny] = size( f );
h4 = h^4;


v=u;


for i=2:ny-1
  for j=2:nx-1
    a1=(u(i+1,j)+u(i-1,j))/2;
    a2=(u(i,j+1)+u(i,j-1))/2;
    a3=(u(i+1,j+1)+u(i-1,j-1))/2;
    a4=(u(i-1,j+1)+u(i+1,j-1))/2;
    
    v(i,j) = 0.5*(a1+a2)-0.5*sqrt((a1-a2)^2+0.25*(a3-a4)^2+h4*f(i,j));
  end
end


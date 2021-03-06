function [Cnew, v] = computeGaussianDisplacement(Q, C)
% Compute the displacements of N particles givent a tensor
%
% v = computeGaussianDisplacement(Q, C)
%
% Q:  The tensor  ADC = uQu'
% C:  x,y,z coordinate for the center of the particles. For N particles
%     C should be an Nx3 array
%
%
% The that the diffusion ellipsoid has a tensor that is inverse to Q. See
% below.
%
% The ellipsoid points are vectors, v, that solve
%
%   vQv = 1
%
% If we find for a unit vector, u, that uQu = k, then the vector 
%    v = u/sqrt(k) 
%
% Then a solution for the ellipsoid will be
%
%    u/sqrt(k) * Q * u/sqrt(k) = 1,
%
% So the points on the ellipsoid are v = u/sqrt(u'Qu)
%
% The diffusion ellipsoid for a tensor, Q, depends on the inverse of Q
% rather than Q.  When the diffusion ADC is large, the ellipsoid will be
% large in that direction.  If we solve the ADC for direction u as above,
% then the length of the solutiion will be (1/ADC)*u, which is small. 
%
% We need a clearer physics explanation of why Q (ADC = uQu') and the
% ellipsoid (ellipsoid solution to inv(Q)) are this way.  Get this for
% class!
%
% So for a tensor that predicts ADC = uQu', we plot the ellipsoid
% corresponding to inv(Q).
%
% Examples:
%  Created from mictSimple data set
%     t = dt6.dt6(50,40,40,:);
%     Q = [t(1), t(4), t(5);
%          t(4), t(2), t(6);
%          t(5), t(6), t(3)];
%     ellipsoidFromTensor(Q,[],20);
%
%     xyzData = ellipsoidFromTensor(Q,[],30);
%     cmap = autumn(255);
%     surf(xyzData.x,xyzData.y,xyzData.z,repmat(256,size(xyzData.z)),'EdgeAlpha',0.1); 
%     axis equal, colormap([cmap; .25 .25 .25]), alpha(0.5)    
%     camlight; lighting phong; material shiny;
%     set(gca, 'Projection', 'perspective');
%
% See also:  s_mictSimple
%
% (c) Stanford VISTA Team
if notDefined('C'), C = [0,0,0]; end % coordinates of the points in 3D space
% number of particles
N = size(C,1);
% Make unit vectors on a sphere
[x,y,z] = sphere(100);
% reorganize the univectors on the sheres (basically the diffusion 
% directions scaled to the unit sphere)
rvecs = [x(:), y(:), z(:)];
n = size(rvecs,1); %number of vectors
% randomly sample n vectors on the sphere
u = rvecs(ceil(rand(N,1).*n),:);

sphAdc = zeros(size(u,1),1);
for ii=1:size(u,1)
    % Notice that this is multiplying by inv(Q), not Q.
    % Uncomment to see the equivalence of
    %sphADC(ii) = u(ii,:)*inv(Q)*u(ii,:)';
     sphAdc(ii) = u(ii,:)*(Q\u(ii,:)');
end

% The sqrt ADC is multipled into the unit vector because the factor is
% multiplied in twice (left and right side of inv(Q)).
v = diag(1 ./ sphAdc.^0.5)*u; 
Cnew = C +v;
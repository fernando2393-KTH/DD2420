# author Olga Mikheeva olgamik@kth.se
# PGM tutorial on Variational Inference
# Bayesian Mixture of Gaussians

import numpy as np
import matplotlib.pyplot as plt
import math


def generate_data(std, k, n, dim=1):
    means = np.random.normal(0.0, std, size=(k, dim))
    data = []
    categories = []
    for i in range(n):
        cat = np.random.choice(k)  # sample component assignment
        categories.append(cat)
        data.append(np.random.multivariate_normal(means[cat, :], np.eye(dim)))  # sample data point from the Gaussian
    return np.stack(data), categories, means


def plot(x, y, c, means, title):
    plt.scatter(x, y, c=c)
    plt.scatter(means[:, 0], means[:, 1], c='r')
    plt.title(title)
    plt.show()


def plot_elbo(elbo):
    plt.plot(elbo)
    plt.title('ELBO')
    plt.show()


def compute_elbo(data, phi, m, s2, sigma2, mu0):
    """ Computes ELBO """
    n, p = data.shape
    k = m.shape[0]

    elbo = 0

    # TODO: compute ELBO
    # expected log prior over mixture assignments
    elbo += (-0.5) * (k * p * np.log(2 * np.pi * sigma2))
    aux = 0
    for i in range(k):
        aux += (s2[i] * p + m[i].T @ m[i] - m[i].T @ mu0 - mu0.T @ m[i] + mu0.T @ mu0)
    aux *= 0.5 * (1 / sigma2)
    elbo += aux

    # expected log prior over mixture locations
    elbo += n * (-np.log(k))

    # expected log likelihood
    # lambda = 1 --> (Discussion)
    lmb = 1
    for i in range(n):
        for j in range(k):
            elbo += phi[i, j] * ((-p / 2) * np.log(2 * np.pi * pow(lmb, 2)) - (1 / (2 * pow(lmb, 2))) * (data[i].T @ data[i] - 
            data[i].T @ m[j] - m[j].T @ data[i] + s2[j] * p + m[j].T @ m[j]))

    # entropy of variational location posterior
    aux = 0
    for i in range(n):
        for j in range(k):
            aux += np.log(phi[i, j]) * phi[i, j]
    elbo -= aux
    
    # entropy of the variational assignment posterior
    aux = 0
    for i in range(k):
        aux += np.log(2 * np.pi) + 2 * np.log(np.sqrt(s2[i])) + 1
    aux *= -p / 2
    elbo -= aux

    return elbo


def cavi(data, k, sigma2, m0, eps=1e-15):
    """ Coordinate ascent Variational Inference for Bayesian Mixture of Gaussians
    :param data: data
    :param k: number of components
    :param sigma2: prior variance
    :param m0: prior mean
    :param eps: stopping condition
    :return (m_k, s2_k, psi_i)
    """
    n, p = data.shape
    # initialize randomly
    m = np.random.normal(0., 1., size=(k, p))
    s2 = np.square(np.random.normal(0., 1., size=(k, 1)))
    phi = np.random.dirichlet(np.ones(k), size=n)
    lbm = 1

    # compute ELBO
    elbo = [compute_elbo(data, phi, m, s2, sigma2, m0)]
    convergence = 1.
    while convergence > eps:  # while ELBO not converged
        # TODO: update categorical
        for i in range(n):
            for j in range(k):
                phi[i, j] = np.exp((data[i].T @ m[j]) / pow(lbm, 2) - (s2[j] * p + m[j].T @ m[j]) / (2 * pow(lbm, 2)))
            phi[i] /= np.sum(phi[i])
        
        # TODO: update posterior parameters for the component means
        for j in range(k):
            aux = 0
            for i in range(n):
                aux += phi[i, j] * (1 / pow(lbm, 2))
            aux += 1 / sigma2
            s2[j] = 1 / aux

        for j in range(k):
            aux = 0
            for i in range(n):
                aux += phi[i, j] * data[i]
            aux *= 1 / pow(lbm, 2)
            aux += m0 / sigma2
            m[j] = aux * s2[j]

        # compute ELBO
        elbo.append(compute_elbo(data, phi, m, s2, sigma2, m0))
        convergence = elbo[-1] - elbo[-2]

    return m, s2, phi, elbo


def main():
    # parameters
    p = 2
    k = 5
    sigma = 5.

    data, categories, means = generate_data(std=sigma, k=k, n=500, dim=p)
    m = list()
    s2 = list()
    psi = list()
    elbo = list()
    best_i = 0
    for i in range(10):
        m_i, s2_i, psi_i, elbo_i = cavi(data, k=k, sigma2=sigma, m0=np.zeros(p))
        m.append(m_i)
        s2.append(s2_i)
        psi.append(psi_i)
        elbo.append(elbo_i)
        if i > 0 and elbo[-1][-1] > elbo[best_i][-1]:
            best_i = i
    class_pred = np.argmax(psi[best_i], axis=1)
    plot(data[:, 0], data[:, 1], categories, means, title='true data')
    plot(data[:, 0], data[:, 1], class_pred, m[best_i], title='posterior')
    plot_elbo(elbo[best_i])

if __name__ == '__main__':
    main()

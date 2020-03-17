import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns
from scipy import stats
from tqdm import tqdm


def gaussian_mixture(a1, a2, mu1, mu2, sigma1, sigma2, x):  # Generates the Gaussian Mixture
    return a1 * stats.norm.pdf(x, mu1, sigma1) + a2 * stats.norm.pdf(x, mu2, sigma2)


def metropolis_hastings(iterations, a1, a2, mu1, mu2, sigma1, sigma2, proposal_variance):
    x_i = 0  # Initialize sample as zero
    accepted = []  # List of accepted samples
    for _ in tqdm(range(iterations)):
        x_star = stats.norm(x_i, proposal_variance).rvs(1)  # Generate sample from proposal distribution
        p_x_star = gaussian_mixture(a1, a2, mu1, mu2, sigma1, sigma2, x_star)  # Generate numerator p(x_star)
        p_x_i = gaussian_mixture(a1, a2, mu1, mu2, sigma1, sigma2, x_i)  # Generate denominator p(x_i)
        q_x_star = stats.norm.pdf(x_star, loc=x_i, scale=proposal_variance)  # Likelihood x_star
        q_x_i = stats.norm.pdf(x_i, loc=x_star, scale=proposal_variance)  # Likelihood x_i
        u = np.random.uniform(0, 1)  # Generate random sample from uniform distribution
        if u < ((p_x_star * q_x_i) / (p_x_i * q_x_star)):  # Check if the sample is accepted
            x_i = x_star  # Update state x as state x_star(i)
            accepted.append(x_i)  # Add accepted sample to the list
        else:
            accepted.append(x_i)  # Not sample update. Append same sample to list
    return np.array(accepted)


def main():
    a1, a2 = 0.5, 0.5  # Factors of the Gaussian Mixture
    mu1, mu2 = 0, 3  # µ of the Gaussian Mixture
    sigma1, sigma2 = 1, 0.5  # sigma of the Gaussian Mixture
    iterations = 10000  # Total number of iterations
    proposal_variance = 100  # Variance of the proposal distribution
    accepted_samples = metropolis_hastings(iterations, a1, a2, mu1, mu2, sigma1, sigma2, proposal_variance)
    fig, ax = plt.subplots()
    sns.distplot(accepted_samples)  # Plotting predicted distribution
    # Generating real distribution
    real_distribution = gaussian_mixture(a1, a2, mu1, mu2, sigma1, sigma2,
                                         np.arange(min(accepted_samples), max(accepted_samples), 1 / iterations))
    sns.lineplot(np.arange(min(accepted_samples), max(accepted_samples), 1 / iterations),
                 np.array(real_distribution), ax=ax, color='r')  # Plotting real distribution
    plt.show()
    plt.plot(accepted_samples)  # Plotting random walk
    plt.xlabel('Iteration')
    plt.ylabel('Value of x')
    plt.show()


if __name__ == "__main__":
    main()

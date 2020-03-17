import matplotlib.pyplot as plt
import numpy as np
import random
import seaborn as sns
from scipy.stats import norm
from tqdm import tqdm
from mpl_toolkits.mplot3d import Axes3D

PLT_LAST = True  # Plotting the last obtained distribution individually


def generate_x(x_old, t, sigma_v, n):
    return (1 / 2) * x_old + 25 * (x_old / (1 + pow(x_old, 2))) + \
           8 * np.cos(1.2 * t) + np.random.normal(0, sigma_v, n)


def generate_y(n, time, sigma_x, sigma_v, sigma_w):
    x = np.zeros((time, n))
    y = np.zeros((time, n))
    # Generating x and y at t=0
    x[0] = np.random.normal(0, sigma_x, n)
    y[0] = (pow(x[0], 2) / 20) + np.random.normal(0, sigma_w, n)
    # Generating remaining x and y
    for t in range(1, time):
        x[t] = generate_x(x[t - 1], t, sigma_v, n)
        y[t] = (pow(x[t], 2) / 20) + np.random.normal(0, sigma_w, n)
    return y


def calculate_weights(x, y, sigma):
    weights = generate_distribution(x, y, sigma)  # Generating weights
    weights /= np.sum(weights)  # Normalizing weights
    return weights


def generate_distribution(x, y, sigma_w):
    return norm.pdf(y, loc=(pow(x, 2) / 20), scale=sigma_w)


def bootstrap(n, time, sigma_x, sigma_v, sigma_w):
    y = generate_y(n, time, sigma_x, sigma_v, sigma_w)  # Obtain y
    x = np.zeros((time, n))  # Initialize x
    positions = np.array(range(0, n))  # Create array of particle positions
    print("Executing bootstrap algorithm...")
    x[0] = np.random.normal(0, sigma_x, n)  # Sample the first x
    weights = calculate_weights(x[0], y[0], sigma_w)
    selection = random.choices(positions, weights=weights, k=n)  # Select randomly according to the weights
    x[0] = x[0, selection]  # Update x at time=0 with the selected samples
    for t in tqdm(range(1, time)):
        x[t] = generate_x(x[t - 1], t, sigma_v, n)  # Sample x given old x
        weights = calculate_weights(x[t], y[t], sigma_w)
        selection = random.choices(positions, weights=weights, k=n)
        x[t] = x[t, selection]  # Update x at time=t with the selected samples

    return x


def main():
    n_plots = 10  # Number of pdf drawn
    n = 25  # Number of bins/cells in grid
    time = 200  # Number of time stamps
    particles = 10000  # Number of particles generated
    sigma_x, sigma_v, sigma_w = np.sqrt(10), np.sqrt(10), np.sqrt(1)  # sigmas of the normal distributions
    x = bootstrap(particles, time, sigma_x, sigma_v, sigma_w)
    # Plotting
    x_grid = np.linspace(-25, 25, n)  # Grid for plotting x
    timestamps = np.arange(0, time, time / n_plots)  # Number of plots (equal distance in between)
    fig = plt.figure()
    ax = fig.add_subplot(111, projection='3d')
    for i in range(len(timestamps)):
        t = timestamps[i] * np.ones(n)  # Generating the time array
        x_aux = x[int(timestamps[i]), :]  # Selecting the proper data for plotting
        density = np.histogram(x_aux, bins=n, density=True)[0]  # Getting the density from the data
        ax.plot(x_grid, t, density)  # Plotting the pdf
    # Last position calculated
    t = (time - 1) * np.ones(n)
    x_aux = x[(time - 1), :]
    density = np.histogram(x_aux, bins=n, density=True)[0]
    ax.plot(x_grid, t, density)
    ax.set_xlabel('$x_{t}$')
    ax.set_ylabel('Time (t)')
    ax.set_zlabel('$p(x_{t}|y_{1:t})$')
    plt.title("Estimated Filtering Distribution")
    plt.show()
    if PLT_LAST:  # Plot the last distribution
        plt.figure()
        sns.distplot(x[time - 1, :])
        plt.show()


if __name__ == "__main__":
    main()

# Zombie Epidemic

This is an Agent Based Model simulator of the Zombie Disease.

## Installation

Install it yourself as:

```
$ gem install benchmark-experiment
```

## Usage

### Run the simulation

With the default parameters, you just type:

```
zombie-epidemic
```

It will store the results as PNG files into the current directory.

### Build the movie from the PNG sequences

```
zombie-epidemic movie
```

## The Model

### Space

The space is a discrete 2D bounded map. Each point `(x, y)` is a square that
could be occupied by an agent or an obstacle.

### Time

The time is discrete. Each time step represents enough time for a normal action,
such as a step. It is about 0.5 second.

### An Agent

An agent is a person charactherized by the following:

* a position, and
* a health state.

Every time step, an agent can:

* walk,
* attack, or
* stay.

Without any cost, an agent perceive:

* his surrounding (obstacles, position of agents), and
* neighbors' status (zombie or not)

The quality of the perceptions and actions are altered by the health state:
a zombie doesn't perceive well, neither it walks well.

### The health state

The disease model SIZX is implemented as the following state transition machine:

```
S -------> I -------> Z -------> X
|          |                     ^
|          |---------------------|
|--------------------------------|
```

## TODO

* other characteristics (e.g. energy level)
* other actions
* other perceptions
* load custom map
* custom strategy

## Contributing

1. Fork it ( https://github.com/toch/zombie_epidemic/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

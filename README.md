# Community License Check

A ruby script to find and check all the necessary licenses for the "TIBCO-Streaming-Community" GitHub repository. The class `CommunityLicenseCheck` can be instantiated with an array of length one with the relative path to the repository, or with a string with the relative path.

After instantiation, you can run the `run` function to get a hash of all the licenses of interest, i.e. a `docs/Components-LICENSE` and individual `components/*/LICENSE` files.

*Note: All tests can be run in a Docker container as well to avoid installation and manual testing.*

## Installation

This project is set up with `bundler`.

To install the required gems:

```
$ bundler install
```

## Testing

The included test does not test the code. Instead, it only checks that the resulting licenses are what is expected for the TIBCO repository. All licenses must be `bsd-3-clause`.

To run the test:

```
$ ruby test/test_community_license_check.rb <path-to-repository-root>
```

## Running tests in a Docker conatainer

Instead of installing the required gems in your system, you can build a docker image to run all the tests in a container.

To build the image, `cd` to the directory containing the Dockerfile and run the commnd:

```
$ docker build . -t license-check
```

After the image has been build, run the following command to start the container and run the tests:

```
$ docker run --rm -ti license-check
```

## Details

* [Ruby](https://www.ruby-lang.org/en/): 2.6.4
* [Licensee](https://github.com/licensee/licensee): 5.12
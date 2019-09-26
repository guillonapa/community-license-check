# Community License Check

A ruby script to find and check all the necessary licenses for the "TIBCO-Streaming-Community" GitHub repository. The class `CommunityLicenseCheck` can be instantiated with an array of length one with the relative path to the repository, or with a string with the relative path.

After instantiation, you can run the `run` function to get a hash of all the licenses of interest, i.e. a `docs/Components-LICENSE` and individual `components/*/LICENSE` files.

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

## Details

* [Ruby](https://www.ruby-lang.org/en/): 2.6.4
* [Licensee](https://github.com/licensee/licensee): 5.12
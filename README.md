# proc_parser

proc_parser provides a Ruby wrapper for /proc data such as those contained in
/proc/mem_info, /proc/stat and /proc/loadavg.

Interested in support of more proc files? Contributions are welcome! You can
either create an [issue](https://github.com/EtienneM/mem_info/issues) or
propose a [pull request](https://github.com/EtienneM/mem_info/pulls).

Wondering the meaning of some fields? Read the manual with [`man 5
proc`](https://linux.die.net/man/5/proc).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'proc_parser'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install proc_parser

## Usage

```ruby
meminfo = ProcParser::MemInfo
memtotal = meminfo.memtotal
memfree = meminfo.memfree
```

## Development

After checking out the repository, run `bin/setup` to install dependencies.
Then, run `bundle exec rake spec` to run the tests. You can also run
`bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To
release a new version, update the version number in `version.rb`, and then run
`bundle exec rake release`, which will create a git tag for the version, push
git commits and tags, and push the `.gem` file to
[rubygems.org](https://rubygems.org).

### Without installing Ruby globally

On my work station, I prefer to use a Docker image with Ruby installed instead
of installing Ruby locally. Hence, any `bundle …` command can be prefixed with
`docker-compose run proc-parser`. For instance, running the tests is done with
the command `docker-compose run proc-parser bundle exec rake spec`.

## Acknowledgment

This gem is a generalization of the wonderful work from
[watsonian](https://github.com/watsonian/) and its
[`mem_info`](https://github.com/watsonian/mem_info/) gem.

## Contributing

Bug reports and pull requests are welcome on GitHub at
https://github.com/EtienneM/proc_parser.

## License

The gem is available as open source under the terms of the [MIT
License](http://opensource.org/licenses/MIT).

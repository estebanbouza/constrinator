![ba](./docs/images/logo.png)

# 
Constrinator allows you to export and visualize which Google Cloud Organization Policy constraints are effective at a given project or folder.

This is useful to
- View the policies on folders / projects hierarchically.
- Run it as a cron job to understand changes made to your organization over time.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'constrinator'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install constrinator

## Usage

Run the command line tool `constrinator` and pass the list of org constraints you are interested on analyzing, as well as the root resource to start analyzing from (organization or folder)

Example:

```
 $ constrinator list --target-constraints constraints/compute.requireOsLogin --root-resource folders/121941704308

Analyzing folder folders/121941704308 Policy Playground
├  Analyzing folder folders/418059633406 Level 1 - Blue
├  ├  Analyzing folder folders/102762894607 Level 2 - Banana
├  ├  ├  Analizing project projects/ebpw-org-constr-level2-banana
├  ├  Analizing project projects/ebpw-org-constr-level1-blue
├  Analyzing folder folders/729565188873 Level 1 - Purple


├ Folder: Policy Playground
    {"booleanPolicy":{"enforced":true},"constraint":"constraints/compute.requireOsLogin"}
  ├ Folder: Level 1 - Blue
      {"booleanPolicy":{"enforced":true},"constraint":"constraints/compute.requireOsLogin"}
    ├ Project: ebpw-org-constr-level1-blue
        {"booleanPolicy"=>{"enforced"=>true}, "constraint"=>"constraints/compute.requireOsLogin"}
    ├ Folder: Level 2 - Banana
        {"booleanPolicy":{},"constraint":"constraints/compute.requireOsLogin"}
      ├ Project: ebpw-org-constr-level2-banana
          {"booleanPolicy"=>{}, "constraint"=>"constraints/compute.requireOsLogin"}
  ├ Folder: Level 1 - Purple
      {"booleanPolicy":{"enforced":true},"constraint":"constraints/compute.requireOsLogin"}

```


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/estebanbouza/constrinator. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## Code of Conduct

Everyone interacting in the Constrinator project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/estebanbouza/constrinator/blob/master/CODE_OF_CONDUCT.md).

## Copyright

Copyright (c) 2020 Esteban. See [MIT License](LICENSE.txt) for further details.
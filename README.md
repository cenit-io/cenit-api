# Cenit API

Provides a Ruby client to interact with a Cenit API using a DSL to route your resources and to build
queries and options for result rendering.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'cenit-api'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install cenit-api

## Usage

Querying Shared Collections from https://cenit.io

```ruby
require 'cenit/api'

Cenit::API.v2.setup.cross_shared_collection.get # { "total_pages": 1, "current_page": 1, "count": 282, "cross_shared_collections": [ { "id": ...
```
Or you can use a constant syntax for the API version

```ruby
Cenit::API::V2.setup.cross_shared_collection.count # 282

```

## CRUD operations

To create objects or access non shared data you must configure your Cenit credentials:

```ruby
Cenit.access_token 'XXXXXXXXXX'
Cenit.access_key   'KKKKKKKKKK'
```

 If you want to use your own instance of Cenit then configure your host URL by:

```ruby
Cenit.host 'my-cenit-host-url'
```

Lets create a JSON data type and some records

```ruby
api = Cenit::API::V2

api.setup.json_data_type.create namespace: 'Test',
                                name: 'Object',
                                schema: {
                                    type: 'object',
                                    properties: {
                                        id: { type: 'integer' },
                                        label: { type: 'string' },
                                        checked: { type: 'boolean' }
                                    },
                                    required: ['label']
                                }
                                # {"success": {"json_data_type": {"id": "58fa2faece50767158000006", "namespace": "Test", "name": "Object",...

api.test.object.create(id: 0, label: 'Label') # {"success": {"object": {"id": 0, "label": "Label"}}}

api.test.object.create((1..10).collect { |i| { id: i, label: "Label #{i}", checked: i.odd? } }) # {"success": {"object": {"id": 10, "label": "Label 10", "checked": false}}}

api.test.object.count # 11

# READ
api.test.object.get     # {"total_pages": 1, "current_page": 1, "count": 11, "objects": [{"id": 0, "label": "Label"}, {"id": 1, "label": "Label 1",...

api.test.object(0).get  # {"id": 0, "label": "Label"}

# UPDATE
api.test.object(0).update(label: 'X') # {"id": 0, "label": "X"}

#DELETE
api.test.object(10).delete  # {"status": "ok"}

api.test.object(10).get     # {"status": "item not found"},

api.test.object(10).get.code    # 404

api.test.object.count       # 10

```

## Query DSL

`cenit-api` use the query DSL defined by `origin` including the Cenit API parameters:

```ruby
api.test.object.where(checked: false).collect { |obj| obj['id'] }               # [2, 4, 6, 8]

api.test.object.where(checked: true).collect { |obj| obj['label'] }             # ["Label 1", "Label 3", "Label 5", "Label 7", "Label 9"]

api.test.object.where(:checked.exists => false).collect { |obj| obj['label'] }  # ["X"]

api.test.object.where(:id.gt => 4).first                                        # {"id": 5, "label": "Label 5", "checked": true}

api.test.object.where(:id.gt => 4).descending(:label).ignore(:checked).first    # {"id": 9, "label": "Label 9"}

api.test.object.limit(2).page(3).get                                            # {"total_pages": 5, "current_page": 3, "count": 10, "objects": [{"id": 4,...

```
## Push API

Lets first create another test data type using the Push API

```ruby
api.setup.push  json_data_type: {
                     namespace: 'Test',
                     name: 'Record',
                     schema: {
                         type: 'object',
                         properties: {
                             name: { type: 'string' },
                             number: { type: 'integer' }
                         }
                     }
                }
                # {"success": {"json_data_types": [{"id": "58fa4efcce50760627000012", "namespace": "Test", "name": "Record",...
```

And then make a data type simultaneous push to the `test` namespace

```ruby
api.test.push   objects: [
                    { id: 10, label: "Label TEN" },
                    { id: 11, label: "Label ELEVEN" }
                ],
                records: [
                    { name: 'Record 1', number: 1 },
                    { name: 'Record 2', number: 2 }
                ]
```

The result should look like

```json
{
    "success": {
        "objects": [
            {"id": 10, "label": "Label TEN", "checked": false},
            {"id": 11, "label": "Label ELEVEN"}
        ],
        "records": [
            {"id": "58fa517fce50760627000017", "name": "Record 1", "number": 1},
            {"id": "58fa5180ce50760627000018", "name": "Record 2", "number": 2}
        ]
    }
}
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/cenit-io/cenit-api. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).


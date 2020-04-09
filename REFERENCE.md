# Reference
<!-- DO NOT EDIT: This document was generated by Puppet Strings -->

## Table of Contents

**Classes**

* [`downtime`](#downtime): 

**Functions**

* [`downtime::in_window`](#downtimein_window): 
* [`downtime::outside_window`](#downtimeoutside_window): 
* [`downtime::upgrade`](#downtimeupgrade): 

## Classes

### downtime

The downtime class.

#### Parameters

The following parameters are available in the `downtime` class.

##### `restricted`

Data type: `Boolean`



Default value: `false`

##### `window`

Data type: `Struct[{
    start_time          => Pattern[/[012]?\d:\d\d/],
    Optional[week_days] => Array[Enum['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday']],
    Optional[hours]     => Variant[Float, Integer],
  }]`



Default value: { start_time => '3:00' }

## Functions

### downtime::in_window

Type: Puppet Language

The downtime::in_window function.

#### `downtime::in_window()`

The downtime::in_window function.

Returns: `Boolean`

### downtime::outside_window

Type: Puppet Language

The downtime::outside_window function.

#### `downtime::outside_window()`

The downtime::outside_window function.

Returns: `Boolean`

### downtime::upgrade

Type: Puppet Language

The downtime::upgrade function.

#### `downtime::upgrade(String $to_version = 'latest')`

The downtime::upgrade function.

Returns: `String`

##### `to_version`

Data type: `String`



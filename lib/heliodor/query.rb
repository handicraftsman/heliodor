# Query which will be executed when #finish is called
# @attr db [Heliodor::DB] Query's database
# @attr table [String] Name of current table
# @attr actions [Array<Hash>] Array of all actions
class Heliodor::Query
  attr_accessor :db, :actions, :table

  # Initializer
  def initialize(db, table, dat)
    @db      = db
    @table   = table
    @full    = dat
    @dat     = @full[@table]
    @actions = []
  end

  # @!group Query Language

  # Insert given data into table
  # @param dat [Any]
  # @return [self]
  def insert(*dat)
    actions << {
      'type' => 'insert',
      'data' => dat
    }
    self
  end

  # Creates table with current name. If it already exists - truncates
  # @return [self]
  def create
    actions << {
      'type' => 'create'
    }
    self
  end

  # If there's no table with current name, creates it
  # @return [self]
  def ensure
    actions << {
      'type' => 'ensure'
    }
    self
  end

  # Filters all items in current table using given block
  # @yield [i] Is executed for each item in table.
  #            Drops values when this block returns false value
  # @return [self]
  def filter(&block)
    actions << {
      'type'  => 'filter',
      'block' => block
    }
    self
  end

  # Edits all items in current table
  # @yield [i] Return updated value to update stuff
  # @example Adding key to each hash in table
  #   db.query('table_name').map do |i|
  #     i[:keyname] = nil
  #   end.write.finish
  # @example Map-reduce method of getting table length
  #   db.query('table_name').map{1}.reduce(&:+).finish # => length
  # @return [self]
  def map(&block)
    actions << {
      'type'  => 'map',
      'block' => block
    }
    self
  end

  # Reduces table to single element using given block
  # @return [self]
  def reduce(&block)
    actions << {
      'type'  => 'reduce',
      'block' => block
    }
    self
  end

  # Renames current table
  # @param to [String]
  # @return [self]
  def rename(to)
    actions << {
      'type' => 'rename',
      'to'   => to
    }
    self
  end

  # Writes changes to database
  # @return [self]
  def write
    actions << {
      'type' => 'write'
    }
    self
  end

  # Selects all values which match given hash
  # @return [self]
  def select(dat = {})
    actions << {
      'type' => 'select',
      'dat'  => dat
    }
    self
  end

  # Updates all items which match first hash by merging them with second hash
  # @return [self]
  def update(dat1 = {}, dat2 = {})
    actions << {
      'type' => 'update',
      'dat1' => dat1,
      'dat2' => dat2
    }
    self
  end

  # Deletes current table. WARNING: writes changes to database
  # @return [self]
  def delete
    actions << {
      'type' => 'delete'
    }
    self
  end

  # Ends query and processes it
  # @return [Array] Data in table
  def finish
    _process
    @dat
  end
  # @!endgroup

  # Inspect method
  def inspect
    %(#<Heliodor::Query:#{object_id.to_s(16)} @table='#{@table}' @db=#{@db}) +
      %( @actions.length=#{@actions.length}>)
  end
end

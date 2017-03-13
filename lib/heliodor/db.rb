# Base class for accessing DBs and building queries
# @attr file [String]
# @attr tsafe [Bool] When true, uses mutexes for building queries
class Heliodor::DB
  attr_accessor :file, :tsafe

  def initialize(file, tsafe = false)
    @tsafe = tsafe
    @mutex = Mutex.new
    @dtable = { 'heliodor_data' => {
      'name'            => 'Heliodor',
      'version'         => Heliodor::VERSION,
      'bson_version'    => Gem.loaded_specs['bson'].version.version,
      'last_write'      => DateTime.now.strftime,
      'ruby_version'    => RUBY_VERSION,
      'ruby_patchlevel' => RUBY_PATCHLEVEL.to_s,
      'ruby_platform'   => RUBY_PLATFORM
    } }
    @file = File.expand_path(file.to_s)

    if File.exist?(@file)
      Zlib::GzipReader.open(File.expand_path(@file)) do |f|
        bb = BSON::ByteBuffer.new(f.read)
        @dat = Hash.from_bson(bb)
        f.close
      end
    else
      Zlib::GzipWriter.open(File.expand_path(@file)) do |f|
        # File.open(@file, 'w') do |f|
        f.write(@dtable.to_bson.to_s)
        @dat = @dtable.clone
        f.close
      end
    end
  end

  # Entry point for building queries
  # @param table [String]
  # @return [Heliodor::Query]
  def query(table)
    if @tsafe
      @mutex.synchronize do
        Heliodor::Query.new(self, table, @dat)
      end
    else
      Heliodor::Query.new(self, table, @dat)
    end
  end

  # Deletes given table
  # @param table [String]
  # @return [self]
  def delete(table)
    if @tsafe
      @mutex.synchronize do
        @dat.delete(table)
        write(dat)
      end
    else
      write(dat)
      @dat.delete(table)
    end
  end

  # Returns array of table names
  # @return [Array<String>] Array of table names
  def tables
    Hash.from_bson(BSON::ByteBuffer.new(File.read(@file))).keys
  end

  # Writes database to file
  # @return [self]
  def write(dat)
    @dat = dat
    File.truncate(@file, 0) if File.exist?(@file)
    Zlib::GzipWriter.open(File.expand_path(@file)) do |f|
      f.write(dat.merge(@dtable).to_bson.to_s)
      f.close
    end
    self
  end

  def inspect
    %(#<Heliodor::DB:#{object_id.to_s(16)} @file='#{@file}'>)
  end
end

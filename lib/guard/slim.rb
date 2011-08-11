require 'guard/guard'
require 'guard/watchers'
require 'slim'

module Guard
  class Slim < Guard
    ALL      = File.join '**', '*'
    Template = ::Slim::Template

    def initialize(watchers = [], options = {})
      @root    = options.delete :root
      @locals  = options.delete(:locals) || {}
      @options = options.delete(:slim) || {}

      super watchers, options
    end

    def run_all
      run_on_change all_paths
    end
    def run_on_change(paths)
      paths.each do |path|
        content = render File.read(path)
        open(build_path(path), 'w') { |file| file << content }
      end
    end

    protected

      def build_path(path)
        dirname  = File.dirname path
        basename = File.basename path, '.slim'
        basename << '.html' if File.extname(basename).empty?
        path     = File.join dirname, path


        @root ? File.join(@root, dirname, basename) : File.join(dirname, basename)
      end
      def render(source)
        Template.new( @options ) { source }.render( @locals )
      end
      def all_paths
        Watchers.match_files self, Dir[ ALL ]
      end

  end
end

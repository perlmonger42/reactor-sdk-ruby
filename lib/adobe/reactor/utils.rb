module Adobe::Reactor
  module Utils
    def self.camelize(underscored_word)
      underscored_word.to_s.gsub(/(?:^|_)(.)/) { $1.upcase }
    end

    def self.classify(table_name)
      camelize singularize(table_name.to_s.sub(/.*\./, ''))
    end

    def self.demodulize(class_name_in_module)
      class_name_in_module.to_s.sub(/^.*::/, '')
    end

    def self.pluralize(word)
      word.to_s.sub(/y$/, 'ie').sub(/([^s])$/, '\1s')
    end

    def self.singularize(word)
      word.to_s.sub(/s$/, '').sub(/ie$/, 'y')
    end

    def self.underscore(camel_cased_word)
      word = camel_cased_word.to_s.dup
      word.gsub!(/::/, '/')
      word.gsub!(/([A-Z]+)([A-Z][a-z])/, '\1_\2')
      word.gsub!(/([a-z\d])([A-Z])/, '\1_\2')
      word.tr! '-', '_'
      word.downcase!
      word
    end

    def self.tableize(word)
      pluralize(underscore(demodulize(word)))
    end

    def self.indifferent_read_access(base = {})
      indifferent = Hash.new do |hash, key|
        hash[key.to_s] if key.is_a? Symbol
      end
      base.each_pair do |key, value|
        if value.is_a? Hash
          value = indifferent_read_access value
        elsif value.respond_to? :each
          if value.respond_to? :map!
            value.map! do |v|
              if v.is_a? Hash
                v = indifferent_read_access v
              end
              v
            end
          else
            value.map do |v|
              if v.is_a? Hash
                v = indifferent_read_access v
              end
              v
            end
          end
        end
        indifferent[key.to_s] = value
      end
      indifferent
    end
  end
end

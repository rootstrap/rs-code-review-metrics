module CodeOwners
  class FileHandler < BaseService
    def initialize(content_file)
      @content_file = content_file
    end

    # \*          - Literal
    # ?<user>     - create a capturing group named "user"
    # \s+@\w+     - main regexp filter: all @users separated by spaces
    # (\g<user>)? - where "user" is the name of a capturing group

    def call
      @content_file.scan(/\*(?<user>\s+@\w+(\g<user>)?)/).flat_map do |one_line_names_string|
        one_line_names_string.first.strip.split(/\s/).map do |name|
          name.scan(/@(\w+)/).flatten.first
        end
      end
    end
  end
end

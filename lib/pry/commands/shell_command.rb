class Pry
  Pry::Commands.create_command(/\.(.*)/) do
    group 'Input and Output'
    description "All text following a '.' is forwarded to the shell."
    command_options :listing => ".<shell command>", :use_prefix => false,
      :takes_block => true

    def process(cmd)
      if cmd =~ /^cd\s+(.+)/i
        dest = $1
        begin
          Dir.chdir File.expand_path(dest)
        rescue Errno::ENOENT
          raise CommandError, "No such directory: #{dest}"
        end
      else
        pass_block(cmd)

        if command_block
          command_block.call `#{cmd}`
        else
          Pry.config.system.call(output, cmd, _pry_)
        end
      end
    end
  end
end

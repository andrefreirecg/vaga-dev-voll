class EnableUuidExtension < ActiveRecord::Migration[7.1]
    def change
        enable_extension 'uuid-ossp'
        enable_extension 'pgcrypto' unless extension_enabled?('pgcrypto')

    end
end

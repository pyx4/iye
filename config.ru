$:.unshift('lib')

require 'i18n_yaml_editor/app'
require 'i18n_yaml_editor/web'

Rack::Utils.key_space_limit = 262144

app = I18nYamlEditor::App.new('./locales')
app.load_translations
app.store.create_missing_keys

# --> Filter

rejected_categories = %w{errors date datetime number support time}
rejected_keys = [
  /^active(model|record).errors.format/,
  /^active(model|record).errors.messages/,
  /^active(model|record).errors.template/,
  /^helpers.select/,
  /^helpers.submit/
]

app.store.categories.reject! { |k| rejected_categories.include? k }
app.store.keys.reject! { |k| rejected_keys.any? { |r| k =~ r } }

# Filter <--

run I18nYamlEditor::Web

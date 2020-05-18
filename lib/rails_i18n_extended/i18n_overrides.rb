require "i18n"

module I18n
  class << self

    def translate_with_default key, options={}, original=nil
      begin
        self.translate_without_default(key, **{raise: true}.update(options))
      rescue => e
        split = key.to_s.split('.')
        if split.size <= 2
          translate_without_default original || key, **options
        else
          v = split.pop
          v2 = split.pop
          split.pop if v2 == 'defaults'
          split << 'defaults' << v
          new_key = split.join('.')
          translate_with_default new_key, options, original || key
        end
      end
    end
    alias_method :translate_without_default, :translate
    alias_method :translate, :translate_with_default
    alias_method :t, :translate

    def translate_with_fallback(key = nil, **options)
      locale = options[:locale] || I18n.locale
      intended_to_raise = options[:raise]
      translate_without_fallback(key, options.dup.update(raise: true))
    rescue I18n::MissingTranslationData => e
      raise if locale == I18n.default_locale && intended_to_raise

      begin
        return translate_without_fallback(key, options.dup.update(locale: I18n.default_locale, raise: true))
      rescue I18n::MissingTranslationData
        raise e if intended_to_raise
      end

      translate_without_fallback(key, options)
    end

    alias_method :translate_without_fallback, :translate
    alias_method :translate, :translate_with_fallback
    alias_method :t, :translate

    def model_key(obj)
      obj.model_name.to_s.underscore.gsub('/', '_')
    end

    def attribute_key(obj, attr)
      "activerecord.attributes.#{model_key(obj)}.#{attr}"
    end

    def custom_attribute_key(obj, attr)
      "activerecord.custom_display_attributes.#{model_key(obj)}.#{attr}"
    end

    def flash(key, params={})
      scope = [:flash] + params[:scope].to_a

      t(key, params.update(scope: scope))
    end

    def notice(key, params={})
      scope = [:notice] + params[:scope].to_a

      flash(key, params.update(scope: scope))
    end

    def alert(key, params={})
      scope = [:alert] + params[:scope].to_a

      flash(key, params.update(scope: scope))
    end

    def error(key, params={})
      scope = [:error] + params[:scope].to_a

      flash(key, params.update(scope: scope))
    end
  end
end

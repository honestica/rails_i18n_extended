require "i18n"
require "rails_i18n_extended/version"
require 'active_record'

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

class String
  def t(params={})
    I18n.t(self, **params)
  end
end

class Time
  def l(params={})
    I18n.l(self, **params)
  end
end

class DateTime
  def l(params={})
    I18n.l(self, **params)
  end
end

class Date
  def l(params={})
    I18n.l(self, **params)
  end
end

class Date
  def l(params={})
    I18n.l(self, **params)
  end
end

class TrueClass
  def t(params={})
    I18n.t(self.to_s, **params)
  end
end

class FalseClass
  def t(params={})
    I18n.t(self.to_s, **params)
  end
end

module RailsI18nExtended
  extend ActiveSupport::Concern

  module ClassMethods
    def t(params={})
      "activerecord.models.#{model_name.to_s.underscore.gsub('/', '_')}".t({count: 1}.update(params))
    end

    def tp(params={})
      t(count: 2)
    end

    def t_scope(scope, params={})
      I18n.t("activerecord.scopes.#{I18n.model_key(self)}.#{scope}", **params)
    end

    def t_panel(panel, params={})
      I18n.t("panels.#{I18n.model_key(self)}.#{panel}", **params)
    end

    def t_action(panel, params={})
      I18n.t("actions.#{I18n.model_key(self)}.#{panel}", **params)
    end

    def t_confirm(panel, params={})
      I18n.t("confirm.#{I18n.model_key(self)}.#{panel}", **params)
    end

    def t_message(panel, params={})
      I18n.t("message.#{I18n.model_key(self)}.#{panel}", **params)
    end

    def t_attr(attr, params={})
      I18n.t(I18n.attribute_key(self, attr), **params)
    end

    def t_custom_attr(attr, params={})
      I18n.t(I18n.custom_attribute_key(self, attr), **params)
    end

    def t_enum(attr, value, params={})
      return unless value.present?

      I18n.t([I18n.attribute_key(self, attr.to_s.pluralize), value].join('.'), **params)
    end
  end

  def t_attr(attr, params={})
    self.class.t_attr(attr, params)
  end

  def t_custom_attr(attr, params={})
    self.class.t_custom_attr(attr, params)
  end

  def t_enum(attr, params={})
    return unless send(attr).present?

    self.class.t_enum(attr, send(attr))
  end
end

class ActiveRecord::Base
  include RailsI18nExtended
end
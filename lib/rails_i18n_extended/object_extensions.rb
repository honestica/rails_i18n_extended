require 'active_record'

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
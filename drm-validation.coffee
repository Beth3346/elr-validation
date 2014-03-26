###############################################################################
# Client-side form validation
###############################################################################
###
jshint -W100
###
"use strict"

( ($) ->
    class DrmForms
        constructor: (@speed = 300) ->
            self = @
            body = $ 'body'

            validateField = (value, validate) ->
                if validate.message isnt null
                    self.issueNotice.call @, validate.status, validate.message, validate.issuer, self.speed
                else
                    self.removeNotice.call @, validate.issuer, self.speed
                self.removeValidationClass.call @, validate.status
                self.applyValidationClass.call @, validate.status

            body.on 'click', ':disabled', (e) ->
                e.preventDefault()

            body.on 'keyup', ':input.drm-valid-integer', ->
                value = self.getValue.call @
                validate = self.validateInteger value
                validateField.call @, value, validate

            body.on 'keyup', ':input.drm-valid-number', ->
                value = self.getValue.call @
                validate = self.validateNumber value
                validateField.call @, value, validate

            body.on 'keyup', ':input.drm-valid-url', ->
                value = self.getValue.call @
                validate = self.validateURL value
                validateField.call @, value, validate

            body.on 'keyup', ':input.drm-valid-phone', ->
                value = self.getValue.call @
                validate = self.validatePhone value
                validateField.call @, value, validate            
            
            body.on 'keyup', ':input.drm-valid-email', ->
                value = self.getValue.call @
                validate = self.validateEmail value
                validateField.call @, value, validate            
            
            body.on 'keyup', ':input.drm-valid-full-name', ->
                value = self.getValue.call @
                validate = self.validateFullName value
                validateField.call @, value, validate            
            
            body.on 'keyup', ':input.drm-valid-alpha', ->
                value = self.getValue.call @
                validate = self.validateAlpha value
                validateField.call @, value, validate            
            
            body.on 'keyup', ':input.drm-valid-alphanum', ->
                value = self.getValue.call @
                validate = self.validateAlphaNum value
                validateField.call @, value, validate            
            
            body.on 'keyup', ':input.drm-valid-alphadash', ->
                value = self.getValue.call @
                validate = self.validateAlphaNumDash value
                validateField.call @, value, validate            
            
            body.on 'keyup', ':input.drm-valid-alpha-num-underscore', ->
                value = self.getValue.call @
                validate = self.validateAlphaNumUnderscore value
                validateField.call @, value, validate            
            
            body.on 'keyup', ':input.drm-valid-no-spaces', ->
                value = self.getValue.call @
                validate = self.validateNoSpaces value
                validateField.call @, value, validate            
            
            body.on 'keyup', ':input.drm-valid-no-tags', ->
                value = self.getValue.call @
                validate = self.validateNoTags value
                validateField.call @, value, validate            
            
            body.on 'keyup', ':input[data-max-value]:not([data-min-value])', ->
                value = self.getValue.call @
                validate = self.validateMaxValue value
                validateField.call @, value, validate            
            
            body.on 'keyup', ':input[data-min-value]:not([data-max-value])', ->
                value = self.getValue.call @
                validate = self.validateMinValue value
                validateField.call @, value, validate            
            
            body.on 'keyup', ':input[data-max-length]:not([data-min-length])', ->
                value = self.getValue.call @
                validate = self.validateMaxLength value
                validateField.call @, value, validate            
            
            body.on 'keyup', ':input[data-min-length]:not([data-max-length])', ->
                value = self.getValue.call @
                validate = self.validateMinLength value
                validateField.call @, value, validate            
            
            body.on 'keyup', ':input[data-min-value][data-max-value]', ->
                value = self.getValue.call @
                validate = self.validateBetweenValue value
                validateField.call @, value, validate            
            
            body.on 'keyup', ':input[data-min-length][data-max-length]', ->
                value = self.getValue.call @
                validate = self.validateBetweenLength value
                validateField.call @, value, validate            
            
            body.on 'keyup', ':input', self.trackLength

            body.on 'keyup', '[required]', -> 
                value = self.getValue.call @
                validate = self.validateRequired value
                validateField.call @, value, validate

            body.on 'blur', ':input:not([required])', ->
                value = self.getValue.call @
                if not value
                    self.removeValidationClass.call @
                    self.removeAllNotices.call @

        trackLength: ->
            that = $ @
            value = $.trim that.val()
            length = value.length
            lengthNotice = that.nextUntil ':input', '.form-length-notice'
            
            createMessage = (length) ->
                message = if length is 1 then "#{length} character" else "#{length} characters"
                message

            if lengthNotice.length is 0
                message = createMessage length
                lengthNotice = $ '<p></p>',
                    text: message
                    class: 'form-length-notice'
                
                lengthNotice.hide().insertAfter(that).show()
            else if length is 0
                lengthNotice.remove()
            else
                message = createMessage length
                lengthNotice.text message

        getValue: ->
            value = $.trim $(@).val()
            value

        issueNotice: (status, message, issuer, speed) ->
            that = $ @
            notice = $ "p.form-#{status}-notice:contains(#{message})"
            
            if notice.length is 0
                notice = $ '<p></p>',
                    text: message,
                    class: "form-#{status}-notice"
                    'data-issuer': issuer
                
                notice.hide().insertAfter(that).slideDown speed

        removeNotice: (issuer, speed) ->
            notice = $ "p[data-issuer='#{issuer}']"
            notice.slideUp speed, -> 
                $(@).remove()

        removeAllNotices: ->
            that = $ @
            notices = that.nextUntil ':input','p.form-success-notice, p.form-warning-notice, p.form-danger-notice'
            notices.slideUp @speed, -> 
                $(@).remove()  

        applyValidationClass: (status) ->
            that = $ @
            switch status
                when 'danger' then that.addClass 'drm-form-danger' 
                when 'warning' then that.addClass 'drm-form-warning'
                when 'success' then that.addClass 'drm-form-success'

        removeValidationClass: (status) ->
            that = $ @

            switch status
                when 'danger'
                    that.removeClass 'drm-form-warning'
                    that.removeClass 'drm-form-success'
                when 'warning'
                    that.removeClass 'drm-form-danger'
                    that.removeClass 'drm-form-success'
                when 'success'
                    that.removeClass 'drm-form-danger'
                    that.removeClass 'drm-form-warning'
                else
                    that.removeClass 'drm-form-danger'
                    that.removeClass 'drm-form-warning'
                    that.removeClass 'drm-form-success'

        validateEmpty: ->
            that = $ @
            value = $.trim that.val()

            if not value
                @removeValidationClass.call that
                @removeAllNotices.call that

        validateRequired: (value) ->
            validate =
                status: null
                message: null
                issuer: 'required'

            if value.length is 0
                validate.message = 'this field is required'
                validate.status = 'danger'
            
            validate

        validateInteger: (value) ->
            validate =
                status: null
                message: null
                issuer: 'integer'
            # an integer can be negative or positive and can include one comma separator followed by exactly 3 numbers
            re = new RegExp "^\\-?\\d*"

            evaluate = (result, value) ->
                if result and value is result
                    validate.status = 'success'
                else
                    validate.message = 'please enter a valid integer'
                    validate.status = 'danger'
                validate.status

            if value?
                result = $.trim re.exec value
                validate.status = evaluate result, value

            validate

        validateNumber: (value) ->
            validate =
                status: null
                message: null
                issuer: 'number'
            re = new RegExp "^\\-?\\d*\\.?\\d*"

            evaluate = (result, value) ->
                if result and value is result
                    validate.status = 'success'
                else
                    validate.message = 'please enter a valid number'
                    validate.status = 'danger'
                validate.status

            if value?
                result = $.trim re.exec value
                validate.status = evaluate result, value      

            validate

        validateURL: (value) ->
            validate =
                status: null
                message: null
                issuer: 'url'
            re = new RegExp '^https?:\\/\\/[\\da-z\\.\\-]+[\\.a-z]{2,6}[\\/\\w/.\\-]*\\/?$','gi'

            evaluate = (result, value) ->
                if result and value is result
                    validate.status = 'success'
                else
                    validate.status = 'danger'
                    validate.message = 'please enter a valid url'
                validate.status

            if value?
                result = $.trim re.exec value
                validate.status = evaluate result, value       

            validate

        validateEmail: (value) ->
            validate =
                status: null
                message: null
                issuer: 'email'
            re = new RegExp '^[a-z][a-z\\-\\_\\.\\d]*@[a-z\\-\\_\\.\\d]*\\.[a-z]{2,6}$','gi'

            evaluate = (result, value) ->
                if result and value is result
                    validate.status = 'success'
                else
                    validate.status = 'danger'
                    validate.message = 'please enter a valid email address'
                validate.status

            if value?
                result = $.trim re.exec value
                validate.status = evaluate result, value

            validate

        validatePhone: (value) ->
            validate =
                status: null
                message: null
                issuer: 'phone'
            # validates United States phone number patterns
            re = new RegExp '^\\(?\\d{3}[\\)\\-\\.]?\\d{3}[\\-\\.]?\\d{4}(?:[xX]\\d+)?$','gi'

            evaluate = (result, value) ->
                if result and value is result
                    validate.status = 'success'
                else
                    validate.status = 'danger'
                    validate.message = 'please enter a valid phone number'
                validate.status

            if value?
                result = $.trim re.exec value
                validate.status = evaluate result, value

            validate

        validateFullName: (value) ->
            validate =
                status: null
                message: null
                issuer: 'fullName'
            # allows alpha . - 
            re = new RegExp '^[a-z]+ [a-z\\.\\- ]+$','gi'

            evaluate = (result, value) ->
                if result and value is result
                    validate.status = 'success'
                else
                    validate.status = 'danger'
                    validate.message = 'please enter your first and last name'
                validate.status

            if value?
                result = $.trim re.exec value
                validate.status = evaluate result, value

            validate

        validateAlpha: (value) ->
            validate =
                status: null
                message: null
                issuer: 'alpha'
            re = new RegExp '^[a-z ]*','gi'

            evaluate = (result, value) ->
                if result and value is result
                    validate.status = 'success'
                else
                    validate.status = 'danger'
                    validate.message = 'please use alpha characters only'
                validate.status

            if value?
                result = $.trim re.exec value
                validate.status = evaluate result, value

            validate

        validateAlphaNum: (value) ->
            validate =
                status: null
                message: null
                issuer: 'alphanum'
            re = new RegExp '^[a-z\\d ]*$','gi'

            evaluate = (result, value) ->
                if result and value is result
                    validate.status = 'success'
                else
                    validate.status = 'danger'
                    validate.message = 'please use alphanumeric characters only'
                validate.status

            if value?
                result = $.trim re.exec value
                validate.status = evaluate result, value

            validate

        validateNoSpaces: (value) ->
            validate =
                status: null
                message: null
                issuer: 'noSpaces'
            re = new RegExp '^\\S*$','gi'

            evaluate = (result, value) ->
                if result and value is result
                    validate.status = 'success'
                else
                    validate.status = 'danger'
                    validate.message = 'no spaces'
                validate.status

            if value?
                result = $.trim re.exec value
                validate.status = evaluate result, value

            validate

        validateAlphaNumDash: (value) ->
            validate =
                status: null
                message: null
                issuer: 'alphaNumDash'
            re = new RegExp '^[a-z\\d- ]*$','gi'

            evaluate = (result, value) ->
                if result and value is result
                    validate.status = 'success'
                else
                    validate.status = 'danger'
                    validate.message = 'please use alphanumeric and dash characters only'
                validate.status

            if value?
                result = $.trim re.exec value
                validate.status = evaluate result, value

            validate

        validateAlphaNumUnderscore: (value) ->
            validate =
                status: null
                message: null
                issuer: 'alphaNumUnderscore'
            # allows alphanumeric characters and underscores; no spaces; recommended for usernames
            re = new RegExp '^[a-z\\d_]*$','gi'

            evaluate = (result, value) ->
                if result and value is result
                    validate.status = 'success'
                else
                    validate.status = 'danger'
                    validate.message = 'please use alphanumeric and underscores only. no spaces'                    
                validate.status

            if value?
                result = $.trim re.exec value
                validate.status = evaluate result, value

            validate

        validateNoTags: (value) ->
            validate =
                status: null
                message: null
                issuer: 'number'
            re = new RegExp '<[a-z]+.*>.*<\/[a-z]+>','i'

            evaluate = (result) ->                
                if result
                    validate.status = 'danger'
                    validate.message = 'no html tags allowed'
                else
                    validate.status = 'success'
                validate.status

            if value?
                result = $.trim re.exec value
                validate.status = evaluate result, value

            validate

        validateMaxValue: (value) ->
            that = $ @
            max = that.data 'max-value'
            value = $.trim that.val()

            evaluate = (max, value) ->
                if value > max
                    validate.status = 'danger'
                    validate.message = "please enter a value that is less than #{max + 1}"                    
                else
                    validate.status = 'success'
                validate.status

            if value?
                validate.status = evaluate max, value

            validate

        validateMinValue: (value) ->
            that = $ @
            min = that.data 'min-value'
            value = $.trim that.val()

            evaluate = (min, value) ->                
                if value < min
                    validate.status = 'danger'
                    validate.message = "please enter a value of at least #{min}"
                else
                    validate.status = 'success'
                validate.status

            if value?
                validate.status = evaluate(min, value)

            validate

        validateBetweenValue: (value) ->
            that = $ @
            min = that.data 'min-value'
            max = that.data 'max-value'
            value = $.trim that.val()

            evaluate = (min, max, value) ->                
                if (value < min) or (value > max)
                    validate.status = 'danger'
                    validate.message = "please enter a value that is between #{min - 1} and #{max + 1}"
                else
                    validate.status = 'success'
                validate.status

            if value?
                validate.status = evaluate min, max, value

            validate

        validateMaxLength: (value) ->
            that = $ @
            max = that.data 'max-length'
            value = $.trim that.val()
            length = value.length

            evaluate = (max, length) ->                
                if length > max
                    validate.status = 'danger'
                    validate.message = "please enter less than #{max + 1} characters"
                else
                    validate.status = 'success'
                validate.status

            if value?
                validate.status = evaluate max, length

            validate

        validateMinLength: (value) ->
            that = $ @
            min = that.data 'min-length'
            value = $.trim that.val()
            length = value.length

            evaluate = (min, length) ->                
                if length < min
                    validate.status = 'danger'
                    validate.message = "please enter at least #{min} characters"
                else
                    validate.status = 'success'
                validate.status

            if value?
                validate.status = evaluate min, length

            validate

        validateBetweenLength: (value) ->
            that = $ @
            min = that.data 'min-length'
            max = that.data 'max-length'
            value = $.trim that.val()
            length = value.length

            evaluate = (min, max, length) ->                
                if (length < min) or (length > max)
                    validate.status = 'danger'
                    validate.message = "please enter a value that is between #{min - 1} and #{max + 1} characters"
                else
                    validate.status = 'success'
                validate.status

            if value?
                validate.status = evaluate min, max, length

            validate

    new DrmForms()
		
) jQuery
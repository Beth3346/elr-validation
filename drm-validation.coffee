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

            patterns =
                # an integer can be negative or positive and can include one comma separator followed by exactly 3 numbers
                integer: new RegExp "^\\-?\\d*"
                number: new RegExp "^\\-?\\d*\\.?\\d*"
                url: new RegExp '^https?:\\/\\/[\\da-z\\.\\-]+[\\.a-z]{2,6}[\\/\\w/.\\-]*\\/?$','gi'
                email: new RegExp '^[a-z][a-z\\-\\_\\.\\d]*@[a-z\\-\\_\\.\\d]*\\.[a-z]{2,6}$','gi'
                # validates United States phone number patterns
                phone: new RegExp '^\\(?\\d{3}[\\)\\-\\.]?\\d{3}[\\-\\.]?\\d{4}(?:[xX]\\d+)?$','gi'
                # allows alpha . - and ensures that the user enters both a first and last name
                fullName: new RegExp '^[a-z]+ [a-z\\.\\- ]+$','gi'
                alpha: new RegExp '^[a-z ]*','gi'
                alphaNum: new RegExp '^[a-z\\d ]*$','gi'
                noSpaces: new RegExp '^\\S*$','gi'
                alphaNumDash: new RegExp '^[a-z\\d- ]*$','gi'
                # allows alphanumeric characters and underscores; no spaces; recommended for usernames
                alphaNumUnderscore: new RegExp '^[a-z\\d_]*$','gi'
                noTags: new RegExp '<[a-z]+.*>.*<\/[a-z]+>','i'
                date: new RegExp ''
                creditCard: new RegExp ''
                cvv: new RegExp ''

            validateField = (value, validate) ->
                if validate.message?
                    self.issueNotice.call @, validate.status, validate.message, validate.issuer, self.speed
                else
                    self.removeNotice.call @, validate.issuer, self.speed
                self.removeValidationClass.call @, validate.status
                self.applyValidationClass.call @, validate.status

            body.on 'click', ':disabled', (e) -> e.preventDefault()

            body.on 'keyup', ':input.drm-valid-integer', ->
                value = self.getValue.call @
                validate = self.validateInteger value, patterns.integer
                validateField.call @, value, validate

            body.on 'keyup', ':input.drm-valid-number', ->
                value = self.getValue.call @
                validate = self.validateNumber value, patterns.number
                validateField.call @, value, validate

            body.on 'keyup', ':input.drm-valid-url', ->
                value = self.getValue.call @
                validate = self.validateURL value, patterns.url
                validateField.call @, value, validate

            body.on 'keyup', ':input.drm-valid-phone', ->
                value = self.getValue.call @
                validate = self.validatePhone value, patterns.phone
                validateField.call @, value, validate            
            
            body.on 'keyup', ':input.drm-valid-email', ->
                value = self.getValue.call @
                validate = self.validateEmail value, patterns.email
                validateField.call @, value, validate            
            
            body.on 'keyup', ':input.drm-valid-full-name', ->
                value = self.getValue.call @
                validate = self.validateFullName value, patterns.fullName
                validateField.call @, value, validate            
            
            body.on 'keyup', ':input.drm-valid-alpha', ->
                value = self.getValue.call @
                validate = self.validateAlpha value, patterns.alpha
                validateField.call @, value, validate            
            
            body.on 'keyup', ':input.drm-valid-alphanum', ->
                value = self.getValue.call @
                validate = self.validateAlphaNum value, patterns.alphaNum
                validateField.call @, value, validate            
            
            body.on 'keyup', ':input.drm-valid-alphadash', ->
                value = self.getValue.call @
                validate = self.validateAlphaNumDash value, patterns.alphaNumDash
                validateField.call @, value, validate            
            
            body.on 'keyup', ':input.drm-valid-alpha-num-underscore', ->
                value = self.getValue.call @
                validate = self.validateAlphaNumUnderscore value, patterns.alphaNumUnderscore
                validateField.call @, value, validate            
            
            body.on 'keyup', ':input.drm-valid-no-spaces', ->
                value = self.getValue.call @
                validate = self.validateNoSpaces value, patterns.noSpaces
                validateField.call @, value, validate            
            
            body.on 'keyup', ':input.drm-valid-no-tags', ->
                value = self.getValue.call @
                validate = self.validateNoTags value, patterns.noTags
                validateField.call @, value, validate            
            
            body.on 'keyup', ':input[data-max-value]:not([data-min-value])', ->
                value = self.getValue.call @
                validate = self.validateMaxValue.call @, value
                validateField.call @, value, validate            
            
            body.on 'keyup', ':input[data-min-value]:not([data-max-value])', ->
                value = self.getValue.call @
                validate = self.validateMinValue.call @, value
                validateField.call @, value, validate            
            
            body.on 'keyup', ':input[data-max-length]:not([data-min-length])', ->
                value = self.getValue.call @
                validate = self.validateMaxLength.call @, value
                validateField.call @, value, validate            
            
            body.on 'keyup', ':input[data-min-length]:not([data-max-length])', ->
                value = self.getValue.call @
                validate = self.validateMinLength.call @, value
                validateField.call @, value, validate            
            
            body.on 'keyup', ':input[data-min-value][data-max-value]', ->
                value = self.getValue.call @
                validate = self.validateBetweenValue.call @, value
                validateField.call @, value, validate            
            
            body.on 'keyup', ':input[data-min-length][data-max-length]', ->
                value = self.getValue.call @
                validate = self.validateBetweenLength.call @, value
                validateField.call @, value, validate            
            
            body.on 'keyup', ':input', self.trackLength

            # validate empty fields
            
            body.on 'blur', '[required]', -> 
                value = self.getValue.call @
                validate = self.validateRequired value
                validateField.call @, value, validate

            body.on 'blur', ':input:not([required])', ->
                value = self.getValue.call @
                if not value
                    self.removeValidationClass.call @
                    self.removeAllNotices.call @, self.speed

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

            if value.length > 0
                return value
            else
                value = null
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

            if notice.length isnt 0
                notice.slideUp speed, ->
                    $(@).remove()

        removeAllNotices: (speed) ->
            that = $ @
            notices = that.nextUntil ':input','p.form-success-notice, p.form-warning-notice, p.form-danger-notice'

            if notices.length isnt 0
                notices.slideUp speed, -> 
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

        validateRequired: (value) ->
            validate =
                status: null
                message: null
                issuer: 'required'

            if value.length is 0
                validate.message = 'this field is required'
                validate.status = 'danger'
            
            validate

        validateInteger: (value, pattern) ->
            validate =
                status: null
                message: null
                issuer: 'integer'

            evaluate = (result, value) ->
                if result and value is result
                    validate.message = null
                    validate.status = 'success'
                else
                    validate.message = 'please enter a valid integer'
                    validate.status = 'danger'
                validate

            if value?
                pattern = new RegExp pattern
                result = $.trim pattern.exec value
                validate = evaluate result, value

            validate

        validateNumber: (value, pattern) ->
            validate =
                status: null
                message: null
                issuer: 'number'

            evaluate = (result, value) ->
                if result and value is result
                    validate.message = null
                    validate.status = 'success'
                else
                    validate.message = 'please enter a valid number'
                    validate.status = 'danger'
                validate

            if value?
                pattern = new RegExp pattern
                result = $.trim pattern.exec value
                validate = evaluate result, value      

            validate

        validateURL: (value, pattern) ->
            validate =
                status: null
                message: null
                issuer: 'url'

            evaluate = (result, value) ->
                if result and value is result
                    validate.message = null
                    validate.status = 'success'
                else
                    validate.status = 'danger'
                    validate.message = 'please enter a valid url'
                validate

            if value?
                pattern = new RegExp pattern
                result = $.trim pattern.exec value
                validate = evaluate result, value       

            validate

        validateEmail: (value, pattern) ->
            validate =
                status: null
                message: null
                issuer: 'email'

            evaluate = (result, value) ->
                if result and value is result
                    validate.message = null
                    validate.status = 'success'
                else
                    validate.status = 'danger'
                    validate.message = 'please enter a valid email address'
                validate

            if value?
                pattern = new RegExp pattern
                result = $.trim pattern.exec value
                validate = evaluate result, value

            validate

        validatePhone: (value, pattern) ->
            validate =
                status: null
                message: null
                issuer: 'phone'

            evaluate = (result, value) ->
                if result and value is result
                    validate.message = null
                    validate.status = 'success'
                else
                    validate.status = 'danger'
                    validate.message = 'please enter a valid phone number'
                validate

            if value?
                pattern = new RegExp pattern
                result = $.trim pattern.exec value
                validate = evaluate result, value

            validate

        validateFullName: (value, pattern) ->
            validate =
                status: null
                message: null
                issuer: 'fullName'

            evaluate = (result, value) ->
                if result and value is result
                    validate.message = null
                    validate.status = 'success'
                else
                    validate.status = 'danger'
                    validate.message = 'please enter your first and last name'
                validate

            if value?
                pattern = new RegExp pattern
                result = $.trim pattern.exec value
                validate = evaluate result, value

            validate

        validateAlpha: (value, pattern) ->
            validate =
                status: null
                message: null
                issuer: 'alpha'

            evaluate = (result, value) ->
                if result and value is result
                    validate.message = null
                    validate.status = 'success'
                else
                    validate.status = 'danger'
                    validate.message = 'please use alpha characters only'
                validate

            if value?
                pattern = new RegExp pattern
                result = $.trim pattern.exec value
                validate = evaluate result, value

            validate

        validateAlphaNum: (value, pattern) ->
            validate =
                status: null
                message: null
                issuer: 'alphanum'

            evaluate = (result, value) ->
                if result and value is result
                    validate.message = null
                    validate.status = 'success'
                else
                    validate.status = 'danger'
                    validate.message = 'please use alphanumeric characters only'
                validate

            if value?
                pattern = new RegExp pattern
                result = $.trim pattern.exec value
                validate = evaluate result, value

            validate

        validateNoSpaces: (value, pattern) ->
            validate =
                status: null
                message: null
                issuer: 'noSpaces'

            evaluate = (result, value) ->
                if result and value is result
                    validate.message = null
                    validate.status = 'success'
                else
                    validate.status = 'danger'
                    validate.message = 'no spaces'
                validate

            if value?
                pattern = new RegExp pattern
                result = $.trim pattern.exec value
                validate = evaluate result, value

            validate

        validateAlphaNumDash: (value, pattern) ->
            validate =
                status: null
                message: null
                issuer: 'alphaNumDash'

            evaluate = (result, value) ->
                if result and value is result
                    validate.message = null
                    validate.status = 'success'
                else
                    validate.status = 'danger'
                    validate.message = 'please use alphanumeric and dash characters only'
                validate

            if value?
                pattern = new RegExp pattern
                result = $.trim pattern.exec value
                validate = evaluate result, value

            validate

        validateAlphaNumUnderscore: (value, pattern) ->
            validate =
                status: null
                message: null
                issuer: 'alphaNumUnderscore'

            evaluate = (result, value) ->
                if result and value is result
                    validate.message = null
                    validate.status = 'success'
                else
                    validate.status = 'danger'
                    validate.message = 'please use alphanumeric and underscores only. no spaces'                    
                validate

            if value?
                pattern = new RegExp pattern
                result = $.trim pattern.exec value
                validate = evaluate result, value

            validate

        validateNoTags: (value, pattern) ->
            validate =
                status: null
                message: null
                issuer: 'number'

            evaluate = (result) ->                
                if result
                    validate.status = 'danger'
                    validate.message = 'no html tags allowed'
                else
                    validate.message = null
                    validate.status = 'success'
                validate

            if value?
                pattern = new RegExp pattern
                result = $.trim pattern.exec value
                validate = evaluate result, value

            validate

        validateDate: (value, pattern) ->
            validate =
                status: null
                message: null
                issuer: 'date'

            evaluate = (result) ->                
                if result
                    validate.status = 'danger'
                    validate.message = 'please provide a valid date'
                else
                    validate.message = null
                    validate.status = 'success'
                validate

            if value?
                pattern = new RegExp pattern
                result = $.trim pattern.exec value
                validate = evaluate result, value

            validate

        validateCreditCard: (value, pattern) ->
            validate =
                status: null
                message: null
                issuer: 'creditCard'

            evaluate = (result) ->                
                if result
                    validate.status = 'danger'
                    validate.message = 'please provide a valid credit card number'
                else
                    validate.message = null
                    validate.status = 'success'
                validate

            if value?
                pattern = new RegExp pattern
                result = $.trim pattern.exec value
                validate = evaluate result, value

            validate

        validateCvv: (value, pattern) ->
            validate =
                status: null
                message: null
                issuer: 'cvv'

            evaluate = (result) ->                
                if result
                    validate.status = 'danger'
                    validate.message = 'please provide a valid cvv'
                else
                    validate.message = null
                    validate.status = 'success'
                validate

            if value?
                pattern = new RegExp pattern
                result = $.trim pattern.exec value
                validate = evaluate result, value

            validate

        validateEqual: (value) ->
            that = $ @
            equal = that.data 'equal'
            validate =
                status: null
                message: null
                issuer: 'equal'

            evaluate = (equal, value) ->
                if value == equal  
                    validate.message = null
                    validate.status = 'success'                
                else
                    validate.status = 'danger'
                    validate.message = "this field should be #{equal}"
                validate

            if value?
                validate = evaluate equal, value

            validate

        validateNotEqual: (value) ->
            that = $ @
            notEqual = that.data 'not-equal'
            validate =
                status: null
                message: null
                issuer: 'notEqual'

            evaluate = (notEqual, value) ->
                if value == notEqual
                    validate.status = 'danger'
                    validate.message = "this field cannot be #{notEqual}"                   
                else
                    validate.message = null
                    validate.status = 'success'
                validate

            if value?
                validate = evaluate notEqual, value

            validate

        validateCheckbox: () ->

        validateRadio: () ->

        validateInList: (value) ->
            that = $ @
            list = that.data 'in-list'
            validate =
                status: null
                message: null
                issuer: 'inList'

            parseList = () ->
                # doSomething

            evaluate = (list, value) ->
                if value == list
                    validate.status = 'danger'
                    validate.message = "this field cannot be #{list}"                   
                else
                    validate.message = null
                    validate.status = 'success'
                validate

            if value?
                validate = evaluate list, value

            validate

        validateNotList: (value) ->
            that = $ @
            notEqual = that.data 'not-equal'
            validate =
                status: null
                message: null
                issuer: 'not-equal'

            evaluate = (notEqual, value) ->
                if value == notEqual
                    validate.status = 'danger'
                    validate.message = "this field cannot be #{notEqual}"                   
                else
                    validate.message = null
                    validate.status = 'success'
                validate

            if value?
                validate = evaluate notEqual, value

            validate

        validateRequiredWith: (value) ->
            that = $ @
            requiredWith = that.data 'required-with'
            validate =
                status: null
                message: null
                issuer: 'not-equal'

            evaluate = (requiredWith, value) ->
                if value == requiredWith
                    validate.status = 'danger'
                    validate.message = "this field is required with #{requiredWith}"                   
                else
                    validate.message = null
                    validate.status = 'success'
                validate

            if value?
                validate = evaluate requiredWith, value

            validate

        validateMaxValue: (value) ->
            that = $ @
            max = that.data 'max-value'
            validate =
                status: null
                message: null
                issuer: 'maxValue'

            evaluate = (max, value) ->
                if value > max
                    validate.status = 'danger'
                    validate.message = "please enter a value that is less than #{max + 1}"                    
                else
                    validate.message = null
                    validate.status = 'success'
                validate

            if value?
                validate = evaluate max, value

            validate

        validateMinValue: (value) ->
            that = $ @
            min = that.data 'min-value'
            validate =
                status: null
                message: null
                issuer: 'minValue'

            evaluate = (min, value) ->                
                if value < min
                    validate.status = 'danger'
                    validate.message = "please enter a value of at least #{min}"
                else
                    validate.message = null
                    validate.status = 'success'
                validate

            if value?
                validate = evaluate(min, value)

            validate

        validateBetweenValue: (value) ->
            that = $ @
            min = that.data 'min-value'
            max = that.data 'max-value'
            validate =
                status: null
                message: null
                issuer: 'betweenValue'

            evaluate = (min, max, value) ->                
                if (value < min) or (value > max)
                    validate.status = 'danger'
                    validate.message = "please enter a value that is between #{min - 1} and #{max + 1}"
                else
                    validate.message = null
                    validate.status = 'success'
                validate

            if value?
                validate = evaluate min, max, value

            validate

        validateMaxLength: (value) ->
            that = $ @
            max = that.data 'max-length'
            validate =
                status: null
                message: null
                issuer: 'maxLength'

            evaluate = (max, length) ->                
                if length > max
                    validate.status = 'danger'
                    validate.message = "please enter less than #{max + 1} characters"
                else
                    validate.message = null
                    validate.status = 'success'
                validate

            if value?
                length = value.length
                validate = evaluate max, length

            validate

        validateMinLength: (value) ->
            that = $ @
            min = that.data 'min-length'
            validate =
                status: null
                message: null
                issuer: 'minLength'

            evaluate = (min, length) ->                
                if length < min
                    validate.status = 'danger'
                    validate.message = "please enter at least #{min} characters"
                else
                    validate.message = null
                    validate.status = 'success'
                validate

            if value?
                length = value.length
                validate = evaluate min, length

            validate

        validateBetweenLength: (value) ->
            that = $ @
            min = that.data 'min-length'
            max = that.data 'max-length'
            validate =
                status: null
                message: null
                issuer: 'betweenLength'

            evaluate = (min, max, length) ->                
                if (length < min) or (length > max)
                    validate.status = 'danger'
                    validate.message = "please enter a value that is between #{min - 1} and #{max + 1} characters"
                else
                    validate.message = null
                    validate.status = 'success'
                validate

            if value?
                length = value.length
                validate = evaluate min, max, length

            validate

    new DrmForms()
		
) jQuery
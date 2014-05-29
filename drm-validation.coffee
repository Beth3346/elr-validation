###############################################################################
# Client-side form validation
###############################################################################
###
jshint -W100
Note: All validation is for United States based dates, times, phone, zip etc.
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
                number: new RegExp "^(?:\\-?\\d+|\\d*)(?:\\.?\\d+|\\d)$"
                url: new RegExp '^https?:\\/\\/[\\da-z\\.\\-]+[\\.a-z]{2,6}[\\/\\w/.\\-]*\\/?$','i'
                email: new RegExp '^[a-z][a-z\\-\\_\\.\\d]*@[a-z\\-\\_\\.\\d]*\\.[a-z]{2,6}$','i'
                # validates 77494 and 77494-3232
                zip: new RegExp '^[0-9]{5}-[0-9]{4}$|^[0-9]{5}$'
                # validates United States phone number patterns
                phone: new RegExp '^\\(?\\d{3}[\\)\\-\\.]?\\d{3}[\\-\\.]?\\d{4}(?:[xX]\\d+)?$','i'
                # allows alpha . - and ensures that the user enters both a first and last name
                fullName: new RegExp '^[a-z]+ [a-z\\.\\- ]+$','i'
                alpha: new RegExp '^[a-z \\-]*','i'
                alphaNum: new RegExp '^[a-z\\d ]*$','i'
                noSpaces: new RegExp '^\\S*$','i'
                alphaNumDash: new RegExp '^[a-z\\d- ]*$','i'
                # allows alphanumeric characters and underscores; no spaces; recommended for usernames
                alphaNumUnderscore: new RegExp '^[a-z\\d_]*$','i'
                noTags: new RegExp '<[a-z]+.*>.*<\/[a-z]+>','i'
                # mm/dd/yyyy
                monthDayYear: new RegExp '^(?:[0]?[1-9]|[1][012]|[1-9])[-\/.](?:[0]?[1-9]|[12][0-9]|[3][01])[-\/.][0-9]{4}$'
                # 00:00pm
                time: new RegExp '^(?:[12][012]|[0]?[0-9]):[012345][0-9](?:am|pm)$', 'i'
                # matched all major cc
                creditCard: new RegExp '^(?:4[0-9]{12}(?:[0-9]{3})?|5[1-5][0-9]{14}|6(?:011|5[0-9][0-9])[0-9]{12}|3[47][0-9]{13}|3(?:0[0-5]|[68][0-9])[0-9]{11}|(?:2131|1800|35\\d{3})\\d{11})$'
                cvv: new RegExp '^[0-9]{3,4}$'

            validateField = (value, validate) ->
                if validate.message?
                    self.issueNotice.call @, validate, self.speed
                else
                    self.removeNotice.call @, validate.issuer, self.speed
                self.removeValidationClass.call @, validate.status
                self.applyValidationClass.call @, validate.status

            body.on 'click', ':disabled', (e) -> e.preventDefault()

            body.on 'keyup', ':input.drm-valid-integer', ->
                value = self.getValue.call @
                validate = self.validateInteger value, patterns.integer
                if validate?
                    validateField.call @, value, validate

            body.on 'keyup', ':input.drm-valid-number', ->
                value = self.getValue.call @
                validate = self.validateNumber value, patterns.number
                if validate?
                    validateField.call @, value, validate

            body.on 'keyup', ':input.drm-valid-url', ->
                value = self.getValue.call @
                validate = self.validateURL value, patterns.url
                if validate?
                    validateField.call @, value, validate

            body.on 'keyup', ':input.drm-valid-phone', ->
                value = self.getValue.call @
                validate = self.validatePhone value, patterns.phone
                if validate?
                    validateField.call @, value, validate
            
            body.on 'keyup', ':input.drm-valid-email', ->
                value = self.getValue.call @
                validate = self.validateEmail value, patterns.email
                if validate?
                    validateField.call @, value, validate
            
            body.on 'keyup', ':input.drm-valid-full-name', ->
                value = self.getValue.call @
                validate = self.validateFullName value, patterns.fullName
                if validate?
                    validateField.call @, value, validate
            
            body.on 'keyup', ':input.drm-valid-alpha', ->
                value = self.getValue.call @
                validate = self.validateAlpha value, patterns.alpha
                if validate?
                    validateField.call @, value, validate
            
            body.on 'keyup', ':input.drm-valid-alphanum', ->
                value = self.getValue.call @
                validate = self.validateAlphaNum value, patterns.alphaNum
                if validate?
                    validateField.call @, value, validate
            
            body.on 'keyup', ':input.drm-valid-alphadash', ->
                value = self.getValue.call @
                validate = self.validateAlphaNumDash value, patterns.alphaNumDash
                if validate?
                    validateField.call @, value, validate
            
            body.on 'keyup', ':input.drm-valid-alpha-num-underscore', ->
                value = self.getValue.call @
                validate = self.validateAlphaNumUnderscore value, patterns.alphaNumUnderscore
                if validate?
                    validateField.call @, value, validate
            
            body.on 'keyup', ':input.drm-valid-no-spaces', ->
                value = self.getValue.call @
                validate = self.validateNoSpaces value, patterns.noSpaces
                if validate?
                    validateField.call @, value, validate
            
            body.on 'keyup', ':input.drm-valid-no-tags', ->
                value = self.getValue.call @
                validate = self.validateNoTags value, patterns.noTags
                if validate?
                    validateField.call @, value, validate
            
            body.on 'keyup', ':input.drm-valid-credit-card', ->
                value = self.getValue.call @
                validate = self.validateCreditCard value, patterns.creditCard
                if validate?
                    validateField.call @, value, validate
            
            body.on 'keyup', ':input.drm-valid-cvv', ->
                value = self.getValue.call @
                validate = self.validateCvv value, patterns.cvv
                if validate?
                    validateField.call @, value, validate
            
            body.on 'keyup', ':input.drm-valid-zip', ->
                value = self.getValue.call @
                validate = self.validateZip value, patterns.zip
                if validate?
                    validateField.call @, value, validate
            
            body.on 'keyup', ':input.drm-valid-month-day-year', ->
                value = self.getValue.call @
                validate = self.validateMonthDayYear value, patterns.monthDayYear
                if validate?
                    validateField.call @, value, validate
            
            body.on 'keyup', ':input.drm-valid-time', ->
                value = self.getValue.call @
                validate = self.validateTime value, patterns.time
                if validate?
                    validateField.call @, value, validate
            
            body.on 'keyup', ':input[data-max-value]:not([data-min-value])', ->
                value = self.getValue.call @
                validate = self.validateMaxValue.call @, value
                if validate?
                    validateField.call @, value, validate
            
            body.on 'keyup', ':input[data-min-value]:not([data-max-value])', ->
                value = self.getValue.call @
                validate = self.validateMinValue.call @, value
                if validate?
                    validateField.call @, value, validate
            
            body.on 'keyup', ':input[data-max-length]:not([data-min-length])', ->
                value = self.getValue.call @
                validate = self.validateMaxLength.call @, value
                if validate?
                    validateField.call @, value, validate
            
            body.on 'keyup', ':input[data-min-length]:not([data-max-length])', ->
                value = self.getValue.call @
                validate = self.validateMinLength.call @, value
                if validate?
                    validateField.call @, value, validate
            
            body.on 'keyup', ':input[data-min-value][data-max-value]', ->
                value = self.getValue.call @
                validate = self.validateBetweenValue.call @, value
                if validate?
                    validateField.call @, value, validate
            
            body.on 'keyup', ':input[data-min-length][data-max-length]', ->
                value = self.getValue.call @
                validate = self.validateBetweenLength.call @, value
                if validate?
                    validateField.call @, value, validate
            
            body.on 'keyup', ':input[data-equal]', ->
                value = self.getValue.call @
                validate = self.validateEqual.call @, value
                if validate?
                    validateField.call @, value, validate
            
            body.on 'keyup', ':input[data-not-equal]', ->
                value = self.getValue.call @
                validate = self.validateNotEqual.call @, value
                if validate?
                    validateField.call @, value, validate
            
            body.on 'keyup', ':input[data-in-list]', ->
                value = self.getValue.call @
                validate = self.validateInList.call @, value
                if validate?
                    validateField.call @, value, validate
            
            body.on 'keyup', ':input[data-not-list]', ->
                value = self.getValue.call @
                validate = self.validateNotList.call @, value
                if validate?
                    validateField.call @, value, validate

            body.on 'keyup', ":input[type='text'], :input[type='url'], :input[type='email'], :input[type='password'], :input[type='tel'], textarea", ->
                value = self.getValue.call @
                validate = self.trackLength.call @, value
                if validate.message?
                    self.issueNotice.call @, validate, self.speed
                else
                    self.removeNotice.call @, validate.issuer, self.speed

            # validate empty fields
            
            body.on 'blur', '[required]', -> 
                value = self.getValue.call @
                validate = self.validateRequired.call @, value
                if validate?
                    validateField.call @, value, validate

            body.on 'blur', ':input:not([required])', ->
                value = self.getValue.call @
                if not value
                    self.removeValidationClass.call @
                    self.removeAllNotices.call @, self.speed
            
            body.on 'blur', ':input[data-required-with]', ->
                value = self.getValue.call @
                validate = self.validateRequiredWith.call @, value
                if validate?
                    validateField.call @, value, validate

        trackLength: (value) ->
            that = $ @
            validate =
                status: 'length'
                message: null
                issuer: 'length-notice'
            if value?
                length = value.length
                validate.message = if length is 1 then "#{length} character" else "#{length} characters"
            validate

        getValue: ->
            value = $.trim $(@).val()

            if value.length > 0 then value else null

        issueNotice: (validate, speed) ->
            that = $ @
            lengthNotice = that.nextUntil ':input', "p.form-length-notice"
            notice = that.nextUntil ':input', "p.form-#{validate.status}-notice:contains(#{validate.message})"

            addNotice = (item) ->
                if that.css('float') isnt 'none'
                    noticeHolder = that.parent 'div.form-notice-holder'
                    if noticeHolder.length is 0
                        that.wrap('<div class="form-notice-holder"></div>').focus()
                        noticeHolder = that.parent 'div.form-notice-holder'
                        item.hide().appendTo(noticeHolder).slideDown speed
                    else
                        item.hide().appendTo(noticeHolder).slideDown speed
                    noticeHolder.children().css 'float', 'none'
                else
                    item.hide().insertAfter(that).slideDown speed
            
            if validate.status is 'length' and lengthNotice.length is 0
                notice = $ '<p></p>',
                    text: validate.message,
                    class: "form-#{validate.status}-notice form-notice"
                    'data-issuer': validate.issuer
                
                addNotice notice

            else if validate.status is 'length'
                lengthNotice.text validate.message

            else if notice.length is 0
                notice = $ '<p></p>',
                    text: validate.message,
                    class: "form-#{validate.status}-notice form-notice"
                    'data-issuer': validate.issuer
                
                addNotice notice

        removeNotice: (issuer, speed) ->
            self = $ @
            notice = self.nextUntil ':input', "p[data-issuer='#{issuer}']"

            if notice.length isnt 0
                notice.slideUp speed, ->
                    that = $ @
                    that.remove()

        removeAllNotices: (speed) ->
            that = $ @
            notices = that.nextUntil ':input','p.form-notice'

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

            if !value
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
                evaluate result, value

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
                evaluate result, value

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
                evaluate result, value

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
                evaluate result, value

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
                evaluate result, value

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
                evaluate result, value

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
                evaluate result, value

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
                evaluate result, value

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
                evaluate result, value

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
                evaluate result, value

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
                evaluate result, value

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
                evaluate result, value

        validateMonthDayYear: (value, pattern) ->
            validate =
                status: null
                message: null
                issuer: 'date'

            evaluate = (result) ->                
                if result
                    validate.message = null
                    validate.status = 'success'
                else
                    validate.status = 'danger'
                    validate.message = 'please provide a valid date'
                validate

            if value?
                pattern = new RegExp pattern
                result = $.trim pattern.exec value
                evaluate result, value

        validateTime: (value, pattern) ->
            validate =
                status: null
                message: null
                issuer: 'time'

            evaluate = (result) ->                
                if result
                    validate.message = null
                    validate.status = 'success'
                else
                    validate.status = 'danger'
                    validate.message = 'please provide a valid time'
                validate

            if value?
                pattern = new RegExp pattern
                result = $.trim pattern.exec value
                evaluate result, value

        validateCreditCard: (value, pattern) ->
            validate =
                status: null
                message: null
                issuer: 'creditCard'

            evaluate = (result) ->                
                if result
                    validate.message = null
                    validate.status = 'success'
                else
                    validate.status = 'danger'
                    validate.message = 'please provide a valid credit card number'
                validate

            if value?
                pattern = new RegExp pattern
                result = $.trim pattern.exec value
                evaluate result, value

        validateCvv: (value, pattern) ->
            validate =
                status: null
                message: null
                issuer: 'cvv'

            evaluate = (result) ->                
                if result
                    validate.message = null
                    validate.status = 'success'
                else
                    validate.status = 'danger'
                    validate.message = 'please provide a valid cvv'
                validate

            if value?
                pattern = new RegExp pattern
                result = $.trim pattern.exec value
                evaluate result, value

        validateZip: (value, pattern) ->
            validate =
                status: null
                message: null
                issuer: 'zip'

            evaluate = (result) ->                
                if result
                    validate.message = null
                    validate.status = 'success'
                else
                    validate.status = 'danger'
                    validate.message = 'please provide a valid zip code'
                validate

            if value?
                pattern = new RegExp pattern
                result = $.trim pattern.exec value
                evaluate result, value

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
                evaluate equal, value

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
                evaluate notEqual, value

        validateCheckbox: () ->

        validateRadio: () ->

        validateSelect: () ->

        validateInList: (value) ->
            that = $ @
            list = that.data 'in-list'
            listItems = []
            listItems = list.split ','

            validate =
                status: null
                message: null
                issuer: 'inList'

            evaluate = (listItems, value) ->
                if $.inArray(value, listItems) is -1
                    list = listItems.join ', '
                    validate.status = 'danger'
                    validate.message = "this field should be one of these: #{list}"                   
                else
                    validate.message = null
                    validate.status = 'success'
                validate

            if value?
                evaluate listItems, value

        validateNotList: (value) ->
            that = $ @
            list = that.data 'not-list'
            listItems = []
            listItems = list.split ','

            validate =
                status: null
                message: null
                issuer: 'notList'

            evaluate = (listItems, value) ->
                if $.inArray(value, listItems) isnt -1
                    list = listItems.join ', '
                    validate.status = 'danger'
                    validate.message = "this field cannot be one of these: #{list}"                   
                else
                    validate.message = null
                    validate.status = 'success'
                validate

            if value?
                evaluate listItems, value

        validateRequiredWith: (value) ->
            that = $ @
            requiredWith = that.data 'required-with'
            validate =
                status: null
                message: null
                issuer: 'not-equal'

            if requiredWith.search(':') isnt -1
                requiredWith = requiredWith.split ':'
                fieldID = requiredWith[0]
                fieldValue = requiredWith[1]
            else
                fieldID = requiredWith

            evaluate = (value, fieldID, fieldValue) ->
                field = $ "##{fieldID}"
                requiredFieldValue = $.trim field.val()

                checkValue = ->
                    if not value
                        validate.status = 'danger'
                        validate.message = "this field is required with #{fieldID}"
                    else
                        validate.message = null
                        validate.status = 'success'
                    validate

                if fieldValue? and (requiredFieldValue is fieldValue)
                    validate = checkValue()
                else if requiredFieldValue.length > 0 and (not fieldValue?)
                    validate = checkValue()
                else if requiredFieldValue.length == 0
                    validate.message = null
                    validate.status = 'success'
                
                validate

            evaluate value, fieldID, fieldValue

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
                evaluate max, value

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
                evaluate min, value

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
                evaluate min, max, value

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
                evaluate max, length

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
                evaluate min, length

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
                evaluate min, max, length

    new DrmForms()
		
) jQuery
###############################################################################
# Client-side form validation
###############################################################################
###
jshint -W100
Note: All validation is for United States based dates, times, phone, zip etc.

Need to add custom messages
###
"use strict"

$ = jQuery
class @DrmValidation
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
            time: new RegExp '^(?:[12][012]:|[0]?[0-9]:)[012345][0-9](?:\/:[012345][0-9])?(?:am|pm)$', 'i'
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

        validateFields = (fields, validate) ->
            if validate.message?
                self.issueNotice.call @, validate, self.speed
                self.issueNotice.call requireField, validate, self.speed
            else
                self.removeNotice.call @, validate.issuer, self.speed
                self.removeNotice.call requireField, validate.issuer, self.speed
            self.removeValidationClass.call @, validate.status
            self.applyValidationClass.call @, validate.status
            self.removeValidationClass.call requireField, validate.status
            self.applyValidationClass.call requireField, validate.status

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
        
        body.on 'change', ':input[data-required-with]', ->
            # need to monitor required field also
            requireFieldId = $(@).data 'required-with'

            if requireFieldId.search(':') isnt -1
                requireFieldId = requireFieldId.split ':'
                fieldId = requireFieldId[0]
            else
                fieldId = requireFieldId
            
            requireField = $ "##{fieldId}"
            validate = self.validateRequiredWith.call @
            # issue and remove notices on both fields
            if validate?
                if validate.message?
                    self.issueNotice.call @, validate, self.speed
                    self.issueNotice.call requireField, validate, self.speed
                else
                    self.removeNotice.call @, validate.issuer, self.speed
                    self.removeNotice.call requireField, validate.issuer, self.speed
                self.removeValidationClass.call @, validate.status
                self.applyValidationClass.call @, validate.status
                self.removeValidationClass.call requireField, validate.status
                self.applyValidationClass.call requireField, validate.status
        
        body.on 'blur', ':input[data-require-with]', ->
            # need to monitor required field also            
            requiredFieldId = $(@).data 'require-with'

            if requiredFieldId.search(':') isnt -1
                requiredFieldId = requiredFieldId.split ':'
                fieldId = requiredFieldId[0]
            else
                fieldId = requiredFieldId

            requiredField = $ "##{fieldId}"
            validate = self.validateRequiredWith.call @
            # issue and remove notices on both fields
            if validate?
                if validate.message?
                    self.issueNotice.call @, validate, self.speed
                    self.issueNotice.call requiredField, validate, self.speed
                else
                    self.removeNotice.call @, validate.issuer, self.speed
                    self.removeNotice.call requiredField, validate.issuer, self.speed
                self.removeValidationClass.call @, validate.status
                self.applyValidationClass.call @, validate.status
                self.removeValidationClass.call requiredField, validate.status
                self.applyValidationClass.call requiredField, validate.status
        
        body.on 'change', ':input[data-allowed-with]', ->
            # remove disabled attribute on related field
            value = self.getValue.call @
            self.validateAllowedWith.call @, value

    trackLength: (value) ->
        _that = $ @
        validate =
            status: 'length'
            message: null
            issuer: 'length-notice'
        if value?
            _length = value.length
            validate.message = if _length is 1 then "#{_length} character" else "#{_length} characters"
        validate

    getValue: ->
        value = $.trim $(@).val()

        if value.length > 0 then value else null

    issueNotice: (validate, speed) ->
        _that = $ @
        lengthNotice = _that.nextUntil ':input', "p.form-length-notice"
        notice = _that.nextUntil ':input', "p.form-#{validate.status}-notice:contains(#{validate.message})"

        _addNotice = (item) ->
            if _that.css('float') isnt 'none'
                _noticeHolder = _that.parent 'div.form-notice-holder'
                if _noticeHolder.length is 0
                    _that.wrap('<div class="form-notice-holder"></div>').focus()
                    _noticeHolder = _that.parent 'div.form-notice-holder'
                    item.hide().appendTo(_noticeHolder).slideDown speed
                else
                    item.hide().appendTo(_noticeHolder).slideDown speed
                _noticeHolder.children().css 'float', 'none'
            else
                item.hide().insertAfter(_that).slideDown speed
        
        if validate.status is 'length' and lengthNotice.length is 0
            notice = $ '<p></p>',
                text: validate.message,
                class: "form-#{validate.status}-notice form-notice"
                'data-issuer': validate.issuer
            
            _addNotice notice

        else if validate.status is 'length'
            lengthNotice.text validate.message

        else if notice.length is 0
            notice = $ '<p></p>',
                text: validate.message,
                class: "form-#{validate.status}-notice form-notice"
                'data-issuer': validate.issuer
            
            _addNotice notice

    removeNotice: (issuer, speed) ->
        self = $ @
        _notice = self.nextUntil ':input', "p[data-issuer='#{issuer}']"

        if _notice.length isnt 0 then _notice.slideUp speed, -> $(@).remove()

    removeAllNotices: (speed) ->
        _that = $ @
        _notices = _that.nextUntil ':input','p.form-notice'

        if _notices.length isnt 0
            _notices.slideUp speed, -> 
                $(@).remove()  

    applyValidationClass: (status) ->
        _that = $ @

        switch status
            when 'danger' then _that.addClass 'drm-form-danger' 
            when 'warning' then _that.addClass 'drm-form-warning'
            when 'success' then _that.addClass 'drm-form-success'

    removeValidationClass: (status) ->
        _that = $ @

        switch status
            when 'danger'
                _that.removeClass 'drm-form-warning'
                _that.removeClass 'drm-form-success'
            when 'warning'
                _that.removeClass 'drm-form-danger'
                _that.removeClass 'drm-form-success'
            when 'success'
                _that.removeClass 'drm-form-danger'
                _that.removeClass 'drm-form-warning'
            else
                _that.removeClass 'drm-form-danger'
                _that.removeClass 'drm-form-warning'
                _that.removeClass 'drm-form-success'

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

        _evaluate = (result, value) ->
            if result and value is result
                validate.message = null
                validate.status = 'success'
            else
                validate.message = 'please enter a valid integer'
                validate.status = 'danger'
            validate

        if value?
            _pattern = new RegExp pattern
            result = $.trim _pattern.exec value
            _evaluate result, value

    validateNumber: (value, pattern) ->
        validate =
            status: null
            message: null
            issuer: 'number'

        _evaluate = (result, value) ->
            if result and value is result
                validate.message = null
                validate.status = 'success'
            else
                validate.message = 'please enter a valid number'
                validate.status = 'danger'
            validate

        if value?
            _pattern = new RegExp pattern
            result = $.trim _pattern.exec value
            _evaluate result, value

    validateURL: (value, pattern) ->
        validate =
            status: null
            message: null
            issuer: 'url'

        _evaluate = (result, value) ->
            if result and value is result
                validate.message = null
                validate.status = 'success'
            else
                validate.status = 'danger'
                validate.message = 'please enter a valid url'
            validate

        if value?
            _pattern = new RegExp pattern
            result = $.trim _pattern.exec value
            _evaluate result, value

    validateEmail: (value, pattern) ->
        validate =
            status: null
            message: null
            issuer: 'email'

        _evaluate = (result, value) ->
            if result and value is result
                validate.message = null
                validate.status = 'success'
            else
                validate.status = 'danger'
                validate.message = 'please enter a valid email address'
            validate

        if value?
            _pattern = new RegExp pattern
            result = $.trim _pattern.exec value
            _evaluate result, value

    validatePhone: (value, pattern) ->
        validate =
            status: null
            message: null
            issuer: 'phone'

        _evaluate = (result, value) ->
            if result and value is result
                validate.message = null
                validate.status = 'success'
            else
                validate.status = 'danger'
                validate.message = 'please enter a valid phone number'
            validate

        if value?
            _pattern = new RegExp pattern
            result = $.trim _pattern.exec value
            _evaluate result, value

    validateFullName: (value, pattern) ->
        validate =
            status: null
            message: null
            issuer: 'fullName'

        _evaluate = (result, value) ->
            if result and value is result
                validate.message = null
                validate.status = 'success'
            else
                validate.status = 'danger'
                validate.message = 'please enter your first and last name'
            validate

        if value?
            _pattern = new RegExp pattern
            result = $.trim _pattern.exec value
            _evaluate result, value

    validateAlpha: (value, pattern) ->
        validate =
            status: null
            message: null
            issuer: 'alpha'

        _evaluate = (result, value) ->
            if result and value is result
                validate.message = null
                validate.status = 'success'
            else
                validate.status = 'danger'
                validate.message = 'please use alpha characters only'
            validate

        if value?
            _pattern = new RegExp pattern
            result = $.trim _pattern.exec value
            _evaluate result, value

    validateAlphaNum: (value, pattern) ->
        validate =
            status: null
            message: null
            issuer: 'alphanum'

        _evaluate = (result, value) ->
            if result and value is result
                validate.message = null
                validate.status = 'success'
            else
                validate.status = 'danger'
                validate.message = 'please use alphanumeric characters only'
            validate

        if value?
            _pattern = new RegExp pattern
            result = $.trim _pattern.exec value
            _evaluate result, value

    validateNoSpaces: (value, pattern) ->
        validate =
            status: null
            message: null
            issuer: 'noSpaces'

        _evaluate = (result, value) ->
            if result and value is result
                validate.message = null
                validate.status = 'success'
            else
                validate.status = 'danger'
                validate.message = 'no spaces'
            validate

        if value?
            _pattern = new RegExp pattern
            result = $.trim _pattern.exec value
            _evaluate result, value

    validateAlphaNumDash: (value, pattern) ->
        validate =
            status: null
            message: null
            issuer: 'alphaNumDash'

        _evaluate = (result, value) ->
            if result and value is result
                validate.message = null
                validate.status = 'success'
            else
                validate.status = 'danger'
                validate.message = 'please use alphanumeric and dash characters only'
            validate

        if value?
            _pattern = new RegExp pattern
            result = $.trim _pattern.exec value
            _evaluate result, value

    validateAlphaNumUnderscore: (value, pattern) ->
        validate =
            status: null
            message: null
            issuer: 'alphaNumUnderscore'

        _evaluate = (result, value) ->
            if result and value is result
                validate.message = null
                validate.status = 'success'
            else
                validate.status = 'danger'
                validate.message = 'please use alphanumeric and underscores only. no spaces'                    
            validate

        if value?
            _pattern = new RegExp pattern
            result = $.trim _pattern.exec value
            _evaluate result, value

    validateNoTags: (value, pattern) ->
        validate =
            status: null
            message: null
            issuer: 'number'

        _evaluate = (result) ->                
            if result
                validate.status = 'danger'
                validate.message = 'no html tags allowed'
            else
                validate.message = null
                validate.status = 'success'
            validate

        if value?
            _pattern = new RegExp pattern
            result = $.trim _pattern.exec value
            _evaluate result, value

    validateMonthDayYear: (value, pattern) ->
        validate =
            status: null
            message: null
            issuer: 'date'

        _evaluate = (result) ->                
            if result
                validate.message = null
                validate.status = 'success'
            else
                validate.status = 'danger'
                validate.message = 'please provide a valid date'
            validate

        if value?
            _pattern = new RegExp pattern
            result = $.trim _pattern.exec value
            _evaluate result, value

    validateTime: (value, pattern) ->
        validate =
            status: null
            message: null
            issuer: 'time'

        _evaluate = (result) ->                
            if result
                validate.message = null
                validate.status = 'success'
            else
                validate.status = 'danger'
                validate.message = 'please provide a valid time'
            validate

        if value?
            _pattern = new RegExp pattern
            result = $.trim _pattern.exec value
            _evaluate result, value

    validateCreditCard: (value, pattern) ->
        validate =
            status: null
            message: null
            issuer: 'creditCard'

        _evaluate = (result) ->                
            if result
                validate.message = null
                validate.status = 'success'
            else
                validate.status = 'danger'
                validate.message = 'please provide a valid credit card number'
            validate

        if value?
            _pattern = new RegExp pattern
            result = $.trim _pattern.exec value
            _evaluate result, value

    validateCvv: (value, pattern) ->
        validate =
            status: null
            message: null
            issuer: 'cvv'

        _evaluate = (result) ->                
            if result
                validate.message = null
                validate.status = 'success'
            else
                validate.status = 'danger'
                validate.message = 'please provide a valid cvv'
            validate

        if value?
            _pattern = new RegExp pattern
            result = $.trim _pattern.exec value
            _evaluate result, value

    validateZip: (value, pattern) ->
        validate =
            status: null
            message: null
            issuer: 'zip'

        _evaluate = (result) ->                
            if result
                validate.message = null
                validate.status = 'success'
            else
                validate.status = 'danger'
                validate.message = 'please provide a valid zip code'
            validate

        if value?
            _pattern = new RegExp pattern
            result = $.trim _pattern.exec value
            _evaluate result, value

    validateEqual: (value) ->
        _that = $ @
        equal = _that.data 'equal'
        validate =
            status: null
            message: null
            issuer: 'equal'

        _evaluate = (equal, value) ->
            if value == equal  
                validate.message = null
                validate.status = 'success'                
            else
                validate.status = 'danger'
                validate.message = "this field should be #{equal}"
            validate

        if value?
            _evaluate equal, value

    validateNotEqual: (value) ->
        _that = $ @
        notEqual = _that.data 'not-equal'
        validate =
            status: null
            message: null
            issuer: 'notEqual'

        _evaluate = (notEqual, value) ->
            if value == notEqual
                validate.status = 'danger'
                validate.message = "this field cannot be #{notEqual}"                   
            else
                validate.message = null
                validate.status = 'success'
            validate

        if value?
            _evaluate notEqual, value

    validateCheckbox: () ->

    validateRadio: () ->

    validateSelect: () ->

    validateInList: (value) ->
        _that = $ @
        list = _that.data 'in-list'
        listItems = []
        listItems = list.split ','

        validate =
            status: null
            message: null
            issuer: 'inList'

        _evaluate = (listItems, value) ->
            if $.inArray(value, listItems) is -1
                _list = listItems.join ', '
                validate.status = 'danger'
                validate.message = "this field should be one of these: #{_list}"                   
            else
                validate.message = null
                validate.status = 'success'
            validate

        if value?
            _evaluate listItems, value

    validateNotList: (value) ->
        _that = $ @
        list = _that.data 'not-list'
        listItems = []
        listItems = list.split ','

        validate =
            status: null
            message: null
            issuer: 'notList'

        _evaluate = (listItems, value) ->
            if $.inArray(value, listItems) isnt -1
                _list = listItems.join ', '
                validate.status = 'danger'
                validate.message = "this field cannot be one of these: #{_list}"                   
            else
                validate.message = null
                validate.status = 'success'
            validate

        if value?
            _evaluate listItems, value

    validateRequiredWith: ->
        # determine whether or not the field is required-with or require-with
        # if field is required-with check to see that it is filled in
        # if field is require-with check to see that required field is filled in
        # if an action takes place on either field remove notices

        _that = $ @
        _requiredWith = _that.data 'required-with'
        _requireWith = _that.data 'require-with'
        console.log 'validating'

        validate =
            status: null
            message: null
            issuer: 'requiredWith'

        if _requiredWith

            if _requiredWith.search(':') isnt -1
                _requiredWith = _requiredWith.split ':'
                fieldId = _requiredWith[0]
                fieldValue = _requiredWith[1]
            else
                fieldId = _requiredWith

        else if _requireWith

            if _requireWith.search(':') isnt -1
                _requireWith = _requireWith.split ':'
                fieldId = _requireWith[0]
                fieldValue = _requireWith[1]
            else
                fieldId = _requireWith

        _evaluate = (fieldId, fieldValue) ->
            # if criteria is met then required field must be filled out
            # fieldId = _that.attr 'id'
            requiredField = if _requiredWith then $("##{fieldId}") else _that
            requiredFieldId = if _requiredWith then fieldId else _that.attr 'id'
            requiredFieldValue = $.trim requiredField.val()
            requireField = if _requireWith then $("##{fieldId}") else _that
            requireFieldValue = $.trim requireField.val()

            _checkValue = ->
                if !requireFieldValue
                    validate.message = null
                    validate.status = 'success'
                else if requireFieldValue? and !fieldValue and !requiredFieldValue
                    validate.message = "#{requiredFieldId} is required"
                    validate.status = 'danger'
                else if (requireFieldValue is fieldValue) and !requiredFieldValue
                    validate.message = "#{requiredFieldId} is required"
                    validate.status = 'danger'
                else if requireFieldValue? and requiredFieldValue?
                    validate.message = null
                    validate.status = 'success'
                validate

            _checkValue()

            validate

        _evaluate fieldId, fieldValue
            
    validateAllowedWith: (value) ->
        _that = $ @
        _allowedWith = _that.data 'allowed-with'

        if _allowedWith.search(':') isnt -1
            _allowedWith = _allowedWith.split ':'
            _allowedId = _allowedWith[0]
            _allowedValue = _allowedWith[1]
        else
            _allowedId = _allowedWith
        
        _allowedField = $ "##{_allowedId}"

        if (value is _allowedValue) or (value? and !_allowedValue)
            _allowedField.prop "disabled", false
        else
            _allowedField.prop("disabled", true).val ''

    validateMaxValue: (value) ->
        _that = $ @
        max = _that.data 'max-value'
        validate =
            status: null
            message: null
            issuer: 'maxValue'

        _evaluate = (max, value) ->
            if value > max
                validate.status = 'danger'
                validate.message = "please enter a value that is less than #{max + 1}"                    
            else
                validate.message = null
                validate.status = 'success'
            validate

        if value?
            _evaluate max, value

    validateMinValue: (value) ->
        _that = $ @
        min = _that.data 'min-value'
        validate =
            status: null
            message: null
            issuer: 'minValue'

        _evaluate = (min, value) ->                
            if value < min
                validate.status = 'danger'
                validate.message = "please enter a value of at least #{min}"
            else
                validate.message = null
                validate.status = 'success'
            validate

        if value?
            _evaluate min, value

    validateBetweenValue: (value) ->
        _that = $ @
        min = _that.data 'min-value'
        max = _that.data 'max-value'
        validate =
            status: null
            message: null
            issuer: 'betweenValue'

        _evaluate = (min, max, value) ->                
            if (value < min) or (value > max)
                validate.status = 'danger'
                validate.message = "please enter a value that is between #{min - 1} and #{max + 1}"
            else
                validate.message = null
                validate.status = 'success'
            validate

        if value?
            _evaluate min, max, value

    validateMaxLength: (value) ->
        _that = $ @
        max = _that.data 'max-length'
        validate =
            status: null
            message: null
            issuer: 'maxLength'

        _evaluate = (max, length) ->
            if length > max
                validate.status = 'danger'
                validate.message = "please enter less than #{max + 1} characters"
            else
                validate.message = null
                validate.status = 'success'
            validate

        if value?
            length = value.length
            _evaluate max, length

    validateMinLength: (value) ->
        _that = $ @
        min = _that.data 'min-length'
        validate =
            status: null
            message: null
            issuer: 'minLength'

        _evaluate = (min, length) ->
            if length < min
                validate.status = 'danger'
                validate.message = "please enter at least #{min} characters"
            else
                validate.message = null
                validate.status = 'success'
            validate

        if value?
            length = value.length
            _evaluate min, length

    validateBetweenLength: (value) ->
        _that = $ @
        min = _that.data 'min-length'
        max = _that.data 'max-length'
        validate =
            status: null
            message: null
            issuer: 'betweenLength'

        _evaluate = (min, max, length) ->
            if (length < min) or (length > max)
                validate.status = 'danger'
                validate.message = "please enter a value that is between #{min - 1} and #{max + 1} characters"
            else
                validate.message = null
                validate.status = 'success'
            validate

        if value?
            length = value.length
            _evaluate min, max, length

new DrmValidation()
import elrUtlities from './elr-utilities';
import elrValidationUtils from './elr-validation-utilities';
const $ = require('jquery');

let elr = elrUtlities();
let elrVal = elrValidationUtils();

const elrValidation = function(params) {
    const self = {};
    const spec = params || {};
    const $body = $('body');

    const validateField = function(value, validate) {
        // const speed;

        // if (validate.message) {
        //     self.issueNotice.call(this, validate, speed);
        // } else {
        //     self.removeNotice.call(this, validate.issuer, speed);
        // }

        // self.removeValidationClass.call(this, validate.status);
        // self.applyValidationClass.call(this, validate.status);
        // console.log(value);
        // console.log(validate);
    };

    const trackLength = function(value) {
        const $that = $(this);
        const validate = {
            status: null,
            message: null,
            issuer: 'length-notice'
        };

        if ( value ) {
            const length = value.length;

            validate.status = length;

            if ( length === 1 ) {
                validate.message = `${length} character`;
            } else {
                validate.message = `${length} characters`;
            }
        }

        return validate;
    };

    const addNotice = function($item) {
        // const $noticeHolder;
        const $that = $(this);

        if ( $that.css('float') !== 'none' ) {
            const $noticeHolder = $that.parent('div.form-notice-holder');
        } else {
            $item.hide().insertAfter($that);
        }
    };

    const issueNotice = function(validate, speed) {
        const $that = $(this);
        const $lengthNotice = $that.nextUntil(':input', 'p.form-length-notice');
    };

    $body.on('click', ':disabled', function(e) {
        e.preventDefault();
    });

    $body.on('keyup', ':input.elr-validate, textarea.elr-validate', function() {
        const value = elr.getValue(this);
        const validate = trackLength.call(this, value);

        // console.log(validate.status);
    });

    $body.on('keyup', ':input.elr-valid-integer', function() {
        const value = elr.getValue($(this));
        const validate = elrVal.integer(value);

        if ( validate ) {
            validateField(value, validate);
        }
    });

    return self;
};

export default elrValidation;
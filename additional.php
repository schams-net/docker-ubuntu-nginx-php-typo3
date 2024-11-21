<?php

// Define a weak/insecure password policy
$GLOBALS['TYPO3_CONF_VARS']['SYS']['passwordPolicies']['insecure'] = [
    'validators' => [
        \TYPO3\CMS\Core\PasswordPolicy\Validator\CorePasswordValidator::class => [
            'options' => [
                'minimumLength' => 2,
                'upperCaseCharacterRequired' => false,
                'lowerCaseCharacterRequired' => false,
                'digitCharacterRequired' => false,
                'specialCharacterRequired' => false
            ]
        ],
        \TYPO3\CMS\Core\PasswordPolicy\Validator\NotCurrentPasswordValidator::class => [
            'options' => [],
            'excludeActions' => [
                \TYPO3\CMS\Core\PasswordPolicy\PasswordPolicyAction::NEW_USER_PASSWORD
            ]
        ]
    ]
];

// Allow the weak/insecure password policy in the backend and frontend
$GLOBALS['TYPO3_CONF_VARS']['BE']['passwordPolicy'] = 'insecure';
$GLOBALS['TYPO3_CONF_VARS']['FE']['passwordPolicy'] = 'insecure';

// Ignore the host pattern (this is insecure!)
$GLOBALS['TYPO3_CONF_VARS']['SYS']['trustedHostsPattern'] = '.*';

// Set the locale used for the file system
$GLOBALS['TYPO3_CONF_VARS']['SYS']['systemLocale'] = 'en_US.utf8';

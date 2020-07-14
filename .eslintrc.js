module.exports = {
  "env": {
    "browser": true,
    "es2020": true,
    "jquery": true,
    "commonjs": true,
  },
  "extends": "eslint:recommended",
  "parserOptions": {
    "ecmaVersion": 11,
    "sourceType": "module"
  },
  "rules": {
    "semi": ["error", "always"],
    "quotes": ["error", "single"]
  }
};

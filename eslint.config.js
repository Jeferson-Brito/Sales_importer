export default [
  {
    ignores: [
      'node_modules',
      'dist',
      // outros padrões que você deseja ignorar
    ],
    rules: {
      // suas regras personalizadas aqui
    },
    env: {
      browser: true,
      es2021: true,
      node: true,
    },
    parserOptions: {
      ecmaVersion: 'latest',
      sourceType: 'module',
    },
  },
  {
    files: ['*.js'],
    rules: {
      // regras específicas para arquivos JS
    },
  },
];
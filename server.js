const express = require("express");
const fs = require("fs");
const path = require("path");

const app = express();
const PORT = 3000;

// Diretório dos scripts
const scriptsDir = path.join(__dirname, "Scripts");

// Serve arquivos estáticos da pasta 'public'
app.use(express.static(path.join(__dirname, "public")));

// Rota para a página inicial
app.get("/", (req, res) => {
  res.sendFile(path.join(__dirname, "public", "index.html"));
});

// Rota para a página de chave
app.get("/key.html", (req, res) => {
  res.sendFile(path.join(__dirname, "public", "key.html"));
});

// Rota para listar os scripts
app.get("/scripts", (req, res) => {
  fs.readdir(scriptsDir, (err, files) => {
    if (err) {
      return res.status(500).send("Erro ao listar os scripts");
    }
    const luaFiles = files.filter((file) => file.endsWith(".lua"));
    res.json(luaFiles);
  });
});

// Rota para obter o conteúdo de um script específico
app.get("/scripts/:name", (req, res) => {
  const scriptName = req.params.name;
  const scriptPath = path.join(scriptsDir, scriptName);

  if (!fs.existsSync(scriptPath)) {
    return res.status(404).send("Script não encontrado");
  }

  const content = fs.readFileSync(scriptPath, "utf-8");
  res.type("text/plain").send(content);
});

// Inicia o servidor
app.listen(PORT, () => {
  console.log(`Servidor rodando em http://localhost:${PORT}`);
});
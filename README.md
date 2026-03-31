# ARKEN Dashboard — Guia de Configuração

## O que é isso
Dashboard financeiro da ARKEN que lê automaticamente a planilha Excel e publica
os dados no GitHub Pages. Os sócios acessam pelo browser, sempre atualizado.

## Estrutura de arquivos
```
arken-dashboard/
├── index.html          ← Dashboard (hospedado no GitHub Pages)
├── data.json           ← Dados exportados da planilha (gerado automaticamente)
├── exportar_dados.py   ← Script que lê a planilha e gera o data.json
├── atualizar.sh        ← Script shell que exporta + faz push para o GitHub
├── com.arken.dashboard.plist ← Agendador automático (launchd macOS)
└── README.md           ← Este arquivo
```

---

## PASSO A PASSO DE CONFIGURAÇÃO (fazer uma vez)

### 1. Mover a pasta para o lugar certo
```bash
mv ~/Desktop/arken-dashboard ~/Desktop/"ARKEN CONSULTORIA"/GridZero/04_Operacoes/
cd ~/Desktop/"ARKEN CONSULTORIA"/GridZero/04_Operacoes/arken-dashboard
```

### 2. Criar repositório no GitHub
1. Acesse https://github.com/new
2. Nome do repositório: `arken-dashboard` (ou o que preferir)
3. Deixe **público** (necessário para GitHub Pages gratuito)
4. Clique em **Create repository**

### 3. Conectar o repositório local ao GitHub
```bash
cd ~/Desktop/"ARKEN CONSULTORIA"/GridZero/04_Operacoes/arken-dashboard

git init
git add .
git commit -m "primeiro commit — dashboard ARKEN"
git branch -M main
git remote add origin https://github.com/SEU_USUARIO/arken-dashboard.git
git push -u origin main
```
> Substitua SEU_USUARIO pelo seu usuário do GitHub

### 4. Ativar o GitHub Pages
1. No GitHub, vá em **Settings → Pages**
2. Source: **Deploy from a branch**
3. Branch: **main** / pasta: **/ (root)**
4. Clique em **Save**
5. Aguarde ~2 minutos — o link ficará disponível em:
   `https://SEU_USUARIO.github.io/arken-dashboard/`

### 5. Testar a exportação manualmente
```bash
cd ~/Desktop/"ARKEN CONSULTORIA"/GridZero/04_Operacoes/arken-dashboard
python3 exportar_dados.py
```
Deve aparecer: `✅ data.json gerado`

### 6. Fazer o primeiro push com dados
```bash
git add data.json
git commit -m "dados iniciais"
git push
```

### 7. Configurar atualização automática diária (launchd)
```bash
# Copiar o agendador para o lugar certo
cp com.arken.dashboard.plist ~/Library/LaunchAgents/

# Ativar
launchctl load ~/Library/LaunchAgents/com.arken.dashboard.plist

# Verificar se está ativo
launchctl list | grep arken
```
A partir daí, todos os dias às 07:00 o Mac vai exportar os dados e publicar
automaticamente no GitHub Pages — sem você precisar fazer nada.

---

## Uso diário

**Para atualizar o dashboard agora (sem esperar as 07h):**
```bash
cd ~/Desktop/"ARKEN CONSULTORIA"/GridZero/04_Operacoes/arken-dashboard
bash atualizar.sh
```

**Para ver o log de atualizações:**
```bash
tail -20 ~/Desktop/"ARKEN CONSULTORIA"/GridZero/04_Operacoes/arken-dashboard/update.log
```

**Para desativar o agendamento automático:**
```bash
launchctl unload ~/Library/LaunchAgents/com.arken.dashboard.plist
```

---

## Link para os sócios
```
https://SEU_USUARIO.github.io/arken-dashboard/
```
Compartilhe este link. Os sócios abrem no browser — sem login, sem instalação.

---

## Importante
- O arquivo `data.json` é gerado pelo `exportar_dados.py` e **não deve ser editado manualmente**
- Se mudar o nome ou localização da planilha, ajuste `PLANILHA_PATH` no `exportar_dados.py`
- O campo `CAIXA_INICIAL` no `exportar_dados.py` deve ser atualizado com o saldo bancário real
- O agendador só roda se o Mac estiver ligado às 07:00 — se estiver desligado, rode manualmente

#image base
FROM node:alpine
#path working
WORKDIR /usr/app
#Copia todos arquvios json para raiz do container
COPY package*json ./
#inicializa o node | comando RUN executado para a instalação das máquina
RUN npm install && npm install ejs
#copy dos arquivos com .dockerignore
COPY . .
#expoem a porta 3000
EXPOSE 3000
#comando separado em um array, comando para executar depois da máquina pronta 
CMD [ "npm","start" ]
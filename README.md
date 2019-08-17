# centos-httpd-php

* Acesse o DockerFile para os detalhes de instalação.
* [Post explicativo]()


# Dicas importantes

* Apenas com as instruções do post do Alvin é possível instalar o PHP 7.2 mais o oci8. 
* Durante meu processo de instalação passei por muitos erros e tentativas fracassadas porque não estava entendendo o erro de `Unable to load dynamic library 'oci8.so'`
* Como desconhecia a relação S.O. x ORACLE-CLI x PHP passei muito tempo tentando instalar ou a versão do ORACLI 11.2 ou 12.2, quando na verdade a propria mensagem de erro informava que a versão esperada era a 18.5
* Enfim serve de lição e aprendizado.

# Comandos úteis

* `tail -f /var/log/httpd/error_log` - Apresenta o log do servidor apache. Útil para tratar erro 500
* `docker build -t getjv/centos-httpd .` - Comando docker para buildar a imagem

# Links de Referência
* [Fórum do Remirepo](https://forum.remirepo.net/viewtopic.php?id=3409) 
* [ALVIN BUNK Blog's](https://alvinbunk.wordpress.com/2018/02/19/installing-oci8-php-7-2-on-rhel-or-centos-6/)
* [Cliente Oracle](http://bit.ly/2INtGwF)
## Usage

```
pip install fabric
vagrant up

# prepare basement image
fab create_basement_image -u vagrant -i ~/.vagrant.d/insecure_private_key -H 192.168.33.12
fab create_web_basement_image -u vagrant -i ~/.vagrant.d/insecure_private_key -H 192.168.33.12

# deploy
fab deploy -u vagrant -i ~/.vagrant.d/insecure_private_key -H 192.168.33.12
```

pipeline {
  agent any

  environment {
    NETWORK = "minprojet_bis_network"
    IMAGE_NAME = "nginx_restaurants"
  }

  stages {

    stage('Checkout') {
      steps {
        checkout scm
      }
    }

    stage('Export from MongoDB') {
      steps {
        sh '''
        echo "=== Export restaurants.json depuis MongoDB ==="

        docker run --rm --network ${NETWORK} \
          -v $WORKSPACE/nginx_app/html:/out mongo:6 \
          bash -c "mongoexport --db=projetdb --collection=restaurants --out=/out/restaurants.json --jsonArray"

        echo "=== Contenu exporté ==="
        ls -lh $WORKSPACE/nginx_app/html
        '''
      }
    }

    stage('Build Nginx Image') {
      steps {
        sh '''
        echo "=== Reconstruction COMPLETE de l'image Nginx ==="
        docker build --no-cache -t ${IMAGE_NAME}:latest ./nginx_app
        '''
      }
    }

    stage('Deploy') {
      steps {
        sh '''
        echo "=== Suppression de l'ancien conteneur ==="
        docker rm -f deploy_nginx || true

        echo "=== Déploiement du nouveau conteneur ==="
        docker run -d --name deploy_nginx --network ${NETWORK} -p 8090:80 ${IMAGE_NAME}:latest
        '''
      }
    }
  }
}

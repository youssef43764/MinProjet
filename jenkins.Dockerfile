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
        docker run --rm --network ${NETWORK} \
          -v $WORKSPACE/nginx_app/html:/out mongo:6 \
          bash -c "mongoexport --db=projetdb --collection=restaurants --out=/out/restaurants.json --jsonArray"
        '''
      }
    }

    stage('Build Nginx Image') {
      steps {
        sh "docker build -t ${IMAGE_NAME}:latest ./nginx_app"
      }
    }

    stage('Deploy') {
      steps {
        sh '''
        docker rm -f deploy_nginx || true
        docker run -d --name deploy_nginx --network ${NETWORK} -p 8090:80 ${IMAGE_NAME}:latest
        '''
      }
    }
  }
}

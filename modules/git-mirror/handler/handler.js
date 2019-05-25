const AWS = require('aws-sdk');
const codebuild = new AWS.CodeBuild();

exports.handler = async function(event, context, callback) {
  await codebuild.startBuild({projectName: process.env.project_name}).promise();

  return {
        statusCode: 200,
        body: 'ok' 
  }
}

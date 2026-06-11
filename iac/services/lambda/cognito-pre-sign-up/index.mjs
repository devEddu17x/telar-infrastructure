import {
  SecretsManagerClient,
  GetSecretValueCommand,
} from "@aws-sdk/client-secrets-manager";

const client = new SecretsManagerClient({});

export const handler = async (event) => {
  const secretArn = process.env.PRE_SIGNUP_SECRET_ARN;
  const incomingSecret = event.request?.clientMetadata?.AWS_COGNITO_INTERNAL_AUTH_TOKEN;

  if (!incomingSecret) {
    throw new Error("Unauthorized: missing registrationSecret in clientMetadata");
  }

  const command = new GetSecretValueCommand({ SecretId: secretArn });
  const response = await client.send(command);
  const expectedSecret = response.SecretString;

  if (incomingSecret !== expectedSecret) {
    throw new Error("Unauthorized: invalid registrationSecret");
  }

  return event;
};
// Create a GitHub Client

const { Octokit } = require("@octokit/rest");
const octokit = new Octokit({
  auth: "your_personal_access_token",
});

//Get the Reference of the Branch
const { data: refData } = await octokit.git.getRef({
    owner: "your_github_username",
    repo: "your_repository_name",
    ref: "heads/branch_name",
  });

// Get the Latest Commit of the Branch
const shaLatestCommit = refData.object.sha;

// Get the Tree of the Latest Commit
const { data: commitData } = await octokit.git.getCommit({
    owner: "your_github_username",
    repo: "your_repository_name",
    commit_sha: shaLatestCommit,
  });

// Get the SHA of the Tree
const shaBaseTree = commitData.tree.sha;

// File Content
const fileContent = "Hello World!";

// Convert the file content to Base64
const fileContentInBase64 = Buffer.from(fileContent).toString("base64");


// Create Blobs for the Files.
const { data: blobData } = await octokit.git.createBlob({
    owner: "your_github_username",
    repo: "your_repository_name",
    content: fileContentInBase64,
    encoding: "base64",
  });

// Get the SHA of the Blob
const shaBlob = blobData.sha;

// Create Tree for the Files
const { data: treeData } = await octokit.git.createTree({
    owner: "your_github_username",
    repo: "your_repository_name",
    base_tree: shaBaseTree,
    tree: [
      {
        path: "path/to/your/file.txt",
        mode: "100644",
        type: "blob",
        sha: shaBlob,
      },
    ],
  });

// Get the SHA of the Tree
const shaNewTree = treeData.sha;

// Create a New Commit
const { data: newCommitData } = await octokit.git.createCommit({
    owner: "your_github_username",
    repo: "your_repository_name",
    message: "Your commit message",
    tree: shaNewTree,
    parents: [shaLatestCommit],
  });

// Get the SHA of the New Commit
const shaNewCommit = newCommitData.sha;

// Update the Reference of the Branch to point to the new commit
await octokit.git.updateRef({
    owner: "your_github_username",
    repo: "your_repository_name",
    ref: "heads/branch_name",
    sha: shaNewCommit,
  });

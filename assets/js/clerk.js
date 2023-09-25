import Clerk from '@clerk/clerk-js';

async function initClerk() {
  const clerkFrontendApi = document.querySelector('[name="clerk_pub_key"]').content;
  const clerk = new Clerk(clerkFrontendApi);
  await clerk.load();
  window.trooper.clerk = clerk;
  const event = new CustomEvent("clerk-loaded");
  document.dispatchEvent(event)
}

export { initClerk }

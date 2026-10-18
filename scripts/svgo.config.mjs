// SVGO settings for svg/. Run before committing new SVGs:
//   npx svgo@4 --config scripts/svgo.config.mjs -rf svg
// Safe settings: keeps viewBox, width/height and IDs (IDs matter when several SVGs are inlined on one page)
export default {
  multipass: true,
  floatPrecision: 2,
  plugins: [
    { name: "preset-default", params: { overrides: { cleanupIds: false } } },
  ],
};

document.addEventListener('DOMContentLoaded', function() {
    loadPackages();
});

async function loadPackages() {
    const packageList = document.getElementById('package-list');
    
    try {
        const response = await fetch('packages.json');
        const data = await response.json();
        
        if (data.packages.length === 0) {
            packageList.innerHTML = '<p class="empty">No packages available yet. Check back soon!</p>';
            return;
        }
        
        let html = '<div class="package-grid">';
        
        data.packages.forEach(pkg => {
            html += `
                <div class="package-card">
                    <h3 class="package-name">${pkg.name}</h3>
                    <div class="package-meta">
                        <span class="version">v${pkg.version}</span>
                        <span class="size">${pkg.size}</span>
                    </div>
                    <p class="package-desc">${pkg.description}</p>
                    <div class="package-install">
                        <code>sudo apt install ${pkg.name}</code>
                    </div>
                </div>
            `;
        });
        
        html += '</div>';
        packageList.innerHTML = html;
        
    } catch (error) {
        packageList.innerHTML = '<p class="error">Failed to load package list.</p>';
        console.error('Error loading packages:', error);
    }
}
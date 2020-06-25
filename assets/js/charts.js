
import * as d3 from 'd3'

export function buildViewsByCountriesChart() {
  const svg = d3.select('svg#places-chart');
  const container = document.getElementById('places-chart-container')
  const data = JSON.parse(container.dataset.views)
  const viewsByPlace = data.map(([country, city, views]) => ({label: `${country || 'Unknown'}, ${city || 'Unknown'}`, color: '#000000', value: views}))

  buildGraph('Views by Place', 'Place', '# Views', viewsByPlace, svg, container)
}

export function buildViewsByLinkChart() {
  const svg = d3.select('svg#views-by-link-chart');
  const container = document.getElementById('views-by-link-chart-container')
  const data = JSON.parse(container.dataset.views)
  const viewsByLink = data.map(([link, views]) => ({label: link, color: '#000000', value: views}))

  buildGraph('Views by Link', 'Link', '# Views', viewsByLink, svg, container)
}

export function clearGraph(selector) {
  d3.selectAll(`${selector} > *`).remove()
}

function buildGraph(title, labelX, labelY, data, svg, container) {
  const margin = 50;
  const width = container.getBoundingClientRect().width - 2 * margin;
  const height = container.getBoundingClientRect().height - 2 * margin;
  const chart = svg.append('g')
    .attr('transform', `translate(${margin}, ${margin})`);

  const xScale = d3.scaleBand()
    .range([0, width])
    .domain(data.map((s) => s.label))
    .padding(0.4)

  const yScale = d3.scaleLinear()
    .range([height, 0])
    .domain([0, 100]);

  const makeXLines = () => d3.axisBottom()
    .scale(xScale)

  const makeYLines = () => d3.axisLeft()
    .scale(yScale)

  chart.append('g')
    .attr('transform', `translate(0, ${height})`)
    .call(d3.axisBottom(xScale));

  chart.append('g')
    .call(d3.axisLeft(yScale));

  chart.append('g')
    .attr('class', 'grid')
    .attr('transform', `translate(0, ${height})`)
    .call(makeXLines()
      .tickSize(-height, 0, 0)
      .tickFormat('')
    )

  chart.append('g')
    .attr('class', 'grid')
    .call(makeYLines()
      .tickSize(-width, 0, 0)
      .tickFormat('')
    )

  const barGroups = chart.selectAll()
    .data(data)
    .enter()
    .append('g')

  barGroups
    .append('rect')
    .attr('class', 'bar')
    .attr('x', (g) => xScale(g.label))
    .attr('y', (g) => yScale(g.value))
    .attr('height', (g) => height - yScale(g.value))
    .attr('width', xScale.bandwidth())
    .on('mouseenter', function (actual, i) {
      svg.selectAll('.value')
        .attr('opacity', 0)

      d3.select(this)
        .transition()
        .duration(300)
        .attr('opacity', 0.6)
        .attr('x', (a) => xScale(a.label) - 5)
        .attr('width', xScale.bandwidth() + 10)

      const y = yScale(actual.value)

      const line = chart.append('line')
        .attr('id', 'limit')
        .attr('x1', 0)
        .attr('y1', y)
        .attr('x2', width)
        .attr('y2', y)

      barGroups.append('text')
        .attr('class', 'divergence')
        .attr('x', (a) => xScale(a.label) + xScale.bandwidth() / 2)
        .attr('y', (a) => yScale(a.value) + 30)
        .attr('fill', 'white')
        .attr('text-anchor', 'middle')
        .text((a, idx) => {
          const divergence = (a.value - actual.value).toFixed(1)

          let text = ''
          if (divergence > 0) text += '+'
          text += `${divergence}`

          return idx !== i ? text : '';
        })

    })
    .on('mouseleave', function () {
      d3.selectAll('.value')
        .attr('opacity', 1)

      d3.select(this)
        .transition()
        .duration(300)
        .attr('opacity', 1)
        .attr('x', (a) => xScale(a.label))
        .attr('width', xScale.bandwidth())

      chart.selectAll('#limit').remove()
      chart.selectAll('.divergence').remove()
    })

  barGroups
    .append('text')
    .attr('class', 'value')
    .attr('x', (a) => xScale(a.label) + xScale.bandwidth() / 2)
    .attr('y', (a) => yScale(a.value) + 30)
    .attr('text-anchor', 'middle')
    .text((a) => `${a.value}`)

  svg
    .append('text')
    .attr('class', 'label')
    .attr('x', -(height / 2) - margin)
    .attr('y', margin / 2.4)
    .attr('transform', 'rotate(-90)')
    .attr('text-anchor', 'middle')
    .text(labelY)

  svg.append('text')
    .attr('class', 'label')
    .attr('x', width / 2 + margin)
    .attr('y', height + margin * 1.7)
    .attr('text-anchor', 'middle')
    .text(labelX)

  svg.append('text')
    .attr('class', 'title')
    .attr('x', width / 2 + margin)
    .attr('y', 40)
    .attr('text-anchor', 'middle')
    .text(title)
}